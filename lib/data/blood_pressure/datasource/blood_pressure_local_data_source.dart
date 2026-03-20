import 'package:dun_diary_app/core/constant/hive_constants.dart';
import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';

/// Local Data Source สำหรับจัดการข้อมูล Blood Pressure Records
///
/// ใช้ Hive เป็น local storage พร้อมระบบ indexing ตามเดือน
/// เพื่อเพิ่มประสิทธิภาพในการค้นหาข้อมูลตามช่วงเวลา
class BloodPressureLocalDataSource {
  /// Box หลักเก็บ BPRecord (key = record.id)
  final Box<BPRecord> _box;

  /// Box สำหรับ Index แยกตามเดือน (key = "2024_01", value = List<id>)
  final Box<List<String>> _indexBox;

  /// Box เก็บ Metadata เช่น minYear, yearCounts
  final Box _metaBox;

  /// Box เก็บ Queue สำหรับการอัปเดตข้อมูล
  final Box<String> _upsertQueue;
  final Box<String> _deleteQueue;

  // Stream Event
  final StreamController<void> _updateStreamController =
      StreamController<void>.broadcast();

  BloodPressureLocalDataSource()
    : _metaBox = Hive.box(HiveBoxName.metaBox),
      _indexBox = Hive.box(HiveBoxName.indexBox),
      _box = Hive.box(HiveBoxName.bpRecord),
      _upsertQueue = Hive.box(HiveBoxName.queueUpsertBox),
      _deleteQueue = Hive.box(HiveBoxName.queueDeleteBox);

  // ===========================================================================
  // 📝 SECTION 1: CRUD Operations
  // ===========================================================================

  /// เพิ่ม Record ใหม่พร้อมอัปเดต Index และ Metadata
  Future<void> addRecord(BPRecord record) async {
    // 1. บันทึก Record
    await _box.put(record.id, record);

    // 2. อัปเดต Index (แยกตามเดือน)
    final indexKey =
        "${record.createdAt.year}_${record.createdAt.month.toString().padLeft(2, '0')}";

    final rawList = _indexBox.get(indexKey) ?? [];
    final List<String> currentIds = List<String>.from(rawList);

    if (!currentIds.contains(record.id)) {
      currentIds.add(record.id);
      await _indexBox.put(indexKey, currentIds);
      AppLogger.debug(
        "Saved to Index [$indexKey]: Total ${currentIds.length} records",
      );
    }

    // 3. อัปเดต Metadata
    await _updateMetaOnAdd(record.createdAt.year);
    _updateStreamController.add(null);
  }

  /// ลบ Record ตาม ID พร้อมอัปเดต Metadata
  Future<void> deleteRecord(String id) async {
    final record = _box.get(id);
    if (record != null) {
      final year = record.createdAt.year;
      await _box.delete(id);
      await _updateMetaOnDelete(year);
      _updateStreamController.add(null);
    }
  }

  /// อัปเดต Record (ใช้เมื่อแก้ไขสถานะ เช่น isSynced)
  Future<void> updateRecord(BPRecord record) async {
    await _box.put(record.id, record);
    _updateStreamController.add(null);
  }

  /// ดึง Record ตาม ID
  BPRecord? getRecordById(String id) {
    return _box.get(id);
  }

  // ===========================================================================
  // 📊 SECTION 2: Query Operations
  // ===========================================================================

  /// ดึง Records ทั้งหมด (เรียงจากใหม่ไปเก่า)
  List<BPRecord> getAllRecords() {
    final list = _box.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  /// ดึง Record ล่าสุดจากทุกวัน
  BPRecord? getLatestRecord() {
    if (_box.isEmpty) return null;
    return _box.values.reduce(
      (curr, next) =>
          curr.createdAt.compareTo(next.createdAt) > 0 ? curr : next,
    );
  }

  /// ดึง Record ล่าสุดของวันนี้
  BPRecord? getLatestTodayRecord() {
    final today = DateTime.now();
    final todayRecords = _box.values.where((record) {
      return record.createdAt.year == today.year &&
          record.createdAt.month == today.month &&
          record.createdAt.day == today.day;
    }).toList();

    if (todayRecords.isEmpty) return null;

    todayRecords.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return todayRecords.first;
  }

  /// ดึง Records ตามเดือน (ใช้ Index เพื่อเพิ่มความเร็ว)
  List<BPRecord> getRecordsByMonth(int year, int month) {
    final indexKey = "${year}_${month.toString().padLeft(2, '0')}";
    final ids = _indexBox.get(indexKey) ?? [];

    return ids.map((id) => _box.get(id)).whereType<BPRecord>().toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  /// ดึง Records ตามช่วงเวลา (start - end)
  ///
  /// Algorithm:
  /// 1. หา Index Keys ทุกเดือนในช่วงเวลา
  /// 2. ดึง Record IDs จากแต่ละ Index
  /// 3. Filter ให้เหลือเฉพาะที่อยู่ในช่วงเวลาจริง
  List<BPRecord> getRecordsByRange(DateTime start, DateTime end) {
    AppLogger.debug(
      "Fetching from ${start.toIso8601String()} to ${end.toIso8601String()}",
    );

    // Step 1: หา Index Keys ทุกเดือนในช่วงเวลา
    Set<String> keys = {};
    DateTime current = DateTime(start.year, start.month);
    DateTime endMonth = DateTime(end.year, end.month);

    while (current.isBefore(endMonth) || current.isAtSameMomentAs(endMonth)) {
      final key = "${current.year}_${current.month.toString().padLeft(2, '0')}";
      keys.add(key);
      current = DateTime(current.year, current.month + 1);
    }

    AppLogger.debug("Index Keys involved: $keys");

    // Step 2: ดึง Records จากทุก Index
    List<BPRecord> results = [];
    for (var key in keys) {
      final ids = _indexBox.get(key) ?? [];
      final records = ids
          .map((id) => _box.get(id))
          .whereType<BPRecord>()
          .toList();
      results.addAll(records);
    }

    AppLogger.debug("Raw Records Found: ${results.length}");

    // Step 3: Filter ให้เหลือเฉพาะที่อยู่ในช่วงเวลาจริง
    final filtered = results.where((r) {
      return r.createdAt.compareTo(start) >= 0 &&
          r.createdAt.compareTo(end) <= 0;
    }).toList();

    // Step 4: เรียงตามวันที่
    filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    AppLogger.debug("Final Filtered Records: ${filtered.length}");
    return filtered;
  }

  // ===========================================================================
  // 🔄 SECTION 3: Sync Queue Operations
  // ===========================================================================

  /// Enqueue Upsert: ใส่ ID ลงคิว "เพิ่ม/แก้ไข"
  /// ใช้เมื่อ: User กดบันทึก หรือ แก้ไขข้อมูล
  Future<void> enqueueUpsert(String id) async {
    // Safety: ถ้า ID นี้เคยอยู่ในถังขยะ (Delete Queue) ให้เอาออกก่อน (แปลว่าเปลี่ยนใจไม่ลบแล้ว)
    if (_deleteQueue.values.contains(id)) {
      final keyMap = _deleteQueue.toMap();
      final keyToDelete = keyMap.keys.firstWhere(
        (k) => keyMap[k] == id,
        orElse: () => null,
      );
      if (keyToDelete != null) await _deleteQueue.delete(keyToDelete);
    }

    // ใส่ลง Upsert Queue (ถ้ามีอยู่แล้ว ไม่ต้องใส่ซ้ำ)
    if (!_upsertQueue.values.contains(id)) {
      await _upsertQueue.add(id);
      AppLogger.debug("Queue: Added $id to Upsert Queue");
    }
  }

  Future<void> enqueueDelete(String id) async {
    // 🔥 MASTER LOGIC: เช็คก่อนว่า ID นี้ "เพิ่งสร้างแบบ Offline" หรือไม่?

    if (_upsertQueue.values.contains(id)) {
      // CASE A: เพิ่งสร้าง (อยู่ใน Upsert) แล้วลบเลย -> เสมือนไม่เคยเกิดขึ้น
      // Action: ลบออกจาก Upsert Queue ทิ้งไปเลย ไม่ต้องส่งอะไรไป Server
      final keyMap = _upsertQueue.toMap();
      final keyToDelete = keyMap.keys.firstWhere(
        (k) => keyMap[k] == id,
        orElse: () => null,
      );

      if (keyToDelete != null) {
        await _upsertQueue.delete(keyToDelete);
        AppLogger.debug(
          "Queue: Cancelled Sync for $id (Created & Deleted offline)",
        );
      }
    } else {
      // CASE B: ข้อมูลเก่าที่มีบน Server แล้ว -> ต้องสั่ง Server ลบด้วย
      // Action: ใส่ลง Delete Queue
      if (!_deleteQueue.values.contains(id)) {
        await _deleteQueue.add(id);
        AppLogger.debug("Queue: Added $id to Delete Queue");
      }
    }
  }

  /// 📤 Getters: ดึงรายการ ID ในคิว
  List<String> getUpsertQueueIds() => _upsertQueue.values.toList();
  List<String> getDeleteQueueIds() => _deleteQueue.values.toList();

  /// ✅ Clear: ลบออกจากคิว Upsert (เมื่อ Sync สำเร็จ)
  Future<void> clearFromUpsertQueue(String id) async {
    final keyMap = _upsertQueue.toMap();
    final keyToDelete = keyMap.keys.firstWhere(
      (k) => keyMap[k] == id,
      orElse: () => null,
    );
    if (keyToDelete != null) await _upsertQueue.delete(keyToDelete);
  }

  /// ✅ Clear: ลบออกจากคิว Delete (เมื่อ Sync สำเร็จ)
  Future<void> clearFromDeleteQueue(String id) async {
    final keyMap = _deleteQueue.toMap();
    final keyToDelete = keyMap.keys.firstWhere(
      (k) => keyMap[k] == id,
      orElse: () => null,
    );
    if (keyToDelete != null) await _deleteQueue.delete(keyToDelete);
  }

  // ===========================================================================
  // 📈 SECTION 4: Metadata Operations
  // ===========================================================================

  /// ดึงปีที่เก่าที่สุดที่มีข้อมูล
  int getMinYear() {
    return _metaBox.get(
      HiveKeys.meta.minYear,
      defaultValue: DateTime.now().year,
    );
  }

  /// ดึงรายการปีที่มีข้อมูล (เรียงจากเก่าไปใหม่)
  List<int> getActiveYears() {
    final rawMap = _metaBox.get(HiveKeys.meta.yearCounts, defaultValue: {});
    final Map<int, int> yearCounts = Map<int, int>.from(rawMap);
    return yearCounts.keys.toList()..sort();
  }

  /// อัปเดต Metadata เมื่อเพิ่ม Record
  Future<void> _updateMetaOnAdd(int year) async {
    final rawMap = _metaBox.get(HiveKeys.meta.yearCounts, defaultValue: {});
    final Map<int, int> yearCounts = Map<int, int>.from(rawMap);

    if (yearCounts.containsKey(year)) {
      yearCounts[year] = yearCounts[year]! + 1;
    } else {
      yearCounts[year] = 1;
    }
    await _metaBox.put(HiveKeys.meta.yearCounts, yearCounts);

    // อัปเดต minYear ถ้าปีใหม่น้อยกว่า
    final int currentMin = _metaBox.get(
      HiveKeys.meta.minYear,
      defaultValue: DateTime.now().year,
    );
    if (year < currentMin) {
      await _metaBox.put(HiveKeys.meta.minYear, year);
    }
  }

  /// อัปเดต Metadata เมื่อลบ Record
  Future<void> _updateMetaOnDelete(int year) async {
    final rawMap = _metaBox.get(HiveKeys.meta.yearCounts, defaultValue: {});
    final Map<int, int> yearCounts = Map<int, int>.from(rawMap);

    if (yearCounts.containsKey(year)) {
      final int newCount = yearCounts[year]! - 1;

      if (newCount <= 0) {
        // ลบปีนี้ออกจาก Map
        yearCounts.remove(year);

        // อัปเดต minYear ถ้าจำเป็น
        final int currentMin = _metaBox.get(
          HiveKeys.meta.minYear,
          defaultValue: DateTime.now().year,
        );

        if (year == currentMin) {
          if (yearCounts.isNotEmpty) {
            final List<int> sortedYears = yearCounts.keys.toList()..sort();
            final int newMin = sortedYears.first;
            await _metaBox.put(HiveKeys.meta.minYear, newMin);
          } else {
            await _metaBox.put(HiveKeys.meta.minYear, DateTime.now().year);
          }
        }
      } else {
        yearCounts[year] = newCount;
      }
      await _metaBox.put(HiveKeys.meta.yearCounts, yearCounts);
    }
  }

  // ===========================================================================
  // 👀 SECTION 5: Stream / Watch Operations
  // ===========================================================================

  /// Stream สำหรับ listen การเปลี่ยนแปลงของ Records
  Stream<dynamic> watchRecords() {
    return _updateStreamController.stream;
  }

  /// 🔧 Debug Mode : Delete All Data
  Future<void> clearAll() async {
    await _box.clear(); // ลบข้อมูลความดัน
    await _indexBox.clear(); // ลบ Index
    await _metaBox.clear(); // ลบสถิติปี
    await _upsertQueue.clear(); // ลบคิว Upsert
    await _deleteQueue.clear(); // ลบคิว Delete
    print("🧹 Local Hive: All boxes cleared!");
  }
}
