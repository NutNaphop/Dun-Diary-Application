import 'package:dun_diary_app/core/constant/hive_constants.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BloodPressureLocalDataSource {
  final Box<BPRecord> _box;
  final Box<List<String>> _indexBox;
  final Box _metaBox;

  BloodPressureLocalDataSource()
    : _metaBox = Hive.box(HiveBoxName.metaBox),
      _indexBox = Hive.box(HiveBoxName.indexBox),
      _box = Hive.box(HiveBoxName.bpRecord);

  // --- Record Management ---
  Future<void> addRecord(BPRecord record) async {
    await _box.put(record.id, record);

    // 2. อัปเดต Index
    final indexKey =
        "${record.createdAt.year}_${record.createdAt.month.toString().padLeft(2, '0')}";

    // ดึง List เดิมมา (ต้องแปลง Type ให้ชัวร์)
    final rawList = _indexBox.get(indexKey) ?? [];
    final List<String> currentIds = List<String>.from(rawList);

    if (!currentIds.contains(record.id)) {
      currentIds.add(record.id);
      await _indexBox.put(indexKey, currentIds);
      print("✅ Saved to Index [$indexKey]: Total ${currentIds.length} records");
    }

    // 3. อัปเดต Meta
    await _updateMetaOnAdd(record.createdAt.year);
  }

  Future<void> deleteRecord(String id) async {
    final record = _box.get(id);
    if (record != null) {
      final year = record.createdAt.year;
      await _box.delete(id);
      await _updateMetaOnDelete(year);
    }
  }

  List<BPRecord> getAllRecords() {
    // เรียงจากใหม่ไปเก่า
    final list = _box.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  // Get Latest Record
  BPRecord? getLatestRecord() {
    if (_box.isEmpty) return null;
    return _box.values.reduce(
      (curr, next) =>
          curr.createdAt.compareTo(next.createdAt) > 0 ? curr : next,
    );
  }

  // Get latest today record
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

  // ฟังก์ชันช่วยสำหรับ Sync
  List<BPRecord> getUnsyncedRecords() {
    return _box.values.where((r) => !r.isSynced).toList();
  }

  // Update Status
  Future<void> updateRecord(BPRecord record) async {
    await record.save();
  }

  // Save id into Queuebox
  Future<void> saveRecordIdToQueueBox(String recordId) async {
    final queueBox = Hive.box<String>(HiveBoxName.QueueBox);
    await queueBox.add(recordId);
  }

  // Get Queue id in the box
  List<String> getAllRecordIdsInQueueBox() {
    final queueBox = Hive.box<String>(HiveBoxName.QueueBox);
    return queueBox.values.toList();
  }

  // Get Record by Id
  BPRecord? getRecordById(String id) {
    return _box.get(id);
  }

  // Delete id from Queuebox
  Future<void> deleteRecordIdFromQueueBox(String recordId) async {
    final queueBox = Hive.box<String>(HiveBoxName.QueueBox);
    final keyToDelete = queueBox.keys.firstWhere(
      (key) => queueBox.get(key) == recordId,
      orElse: () => null,
    );

    if (keyToDelete != null) {
      await queueBox.delete(keyToDelete);
      print("🗑️ Deleted record ID $recordId from QueueBox");
    }
  }

  // Watch Record
  Stream<dynamic> watchRecords() {
    return _box.watch();
  }

  // --- Metadata ---
  Future<void> _updateMetaOnAdd(int year) async {
    final rawMap = _metaBox.get(HiveKeys.meta.yearCounts, defaultValue: {});
    final Map<int, int> yearCounts = Map<int, int>.from(rawMap);

    if (yearCounts.containsKey(year)) {
      yearCounts[year] = yearCounts[year]! + 1;
    } else {
      yearCounts[year] = 1;
    }
    await _metaBox.put(HiveKeys.meta.yearCounts, yearCounts);
    final int currentMin = _metaBox.get(
      HiveKeys.meta.minYear,
      defaultValue: DateTime.now().year,
    );
    if (year < currentMin) {
      await _metaBox.put(HiveKeys.meta.minYear, year);
    }
  }

  Future<void> _updateMetaOnDelete(int year) async {
    final rawMap = _metaBox.get(HiveKeys.meta.yearCounts, defaultValue: {});
    final Map<int, int> yearCounts = Map<int, int>.from(rawMap);

    if (yearCounts.containsKey(year)) {
      final int newCount = yearCounts[year]! - 1;

      if (newCount <= 0) {
        yearCounts.remove(year);
        final int currentMin = _metaBox.get(
          HiveKeys.meta.minYear,
          defaultValue: DateTime.now().year,
        );

        // Check is year is currentMin ?
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

  int getMinYear() {
    return _metaBox.get(
      HiveKeys.meta.minYear,
      defaultValue: DateTime.now().year,
    );
  }

  List<int> getActiveYears() {
    final rawMap = _metaBox.get(HiveKeys.meta.yearCounts, defaultValue: {});
    final Map<int, int> yearCounts = Map<int, int>.from(rawMap);
    return yearCounts.keys.toList()..sort();
  }

  // -----------------------------------------------------
  // RANGE MANAGEMENT FUNCTIONS
  // -----------------------------------------------------
  List<BPRecord> getRecordsByMonth(int year, int month) {
    final indexKey = "${year}_${month.toString().padLeft(2, '0')}";
    final ids = _indexBox.get(indexKey) ?? [];

    return ids.map((id) => _box.get(id)).whereType<BPRecord>().toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  List<BPRecord> getRecordsByRange(DateTime start, DateTime end) {
    print(
      "🔍 Fetching from ${start.toIso8601String()} to ${end.toIso8601String()}",
    );

    Set<String> keys = {};

    // 🔥 แก้บั๊ก: วนลูปเก็บ Key ทุกเดือนในช่วงเวลา
    DateTime current = DateTime(start.year, start.month);
    // ปัดเศษ end ไปเป็นวันสุดท้ายของเดือนเพื่อให้ครอบคลุม
    DateTime endMonth = DateTime(end.year, end.month);

    while (current.isBefore(endMonth) || current.isAtSameMomentAs(endMonth)) {
      final key = "${current.year}_${current.month.toString().padLeft(2, '0')}";
      keys.add(key);
      // ขยับไปเดือนถัดไป
      current = DateTime(current.year, current.month + 1);
    }

    print("📂 Index Keys involved: $keys");

    List<BPRecord> results = [];

    for (var key in keys) {
      final ids = _indexBox.get(key) ?? [];
      // print("  - Box [$key] has ${ids.length} IDs"); // เปิดถ้าอยากดูละเอียด

      final records = ids
          .map((id) => _box.get(id))
          .whereType<BPRecord>() // กรอง null ทิ้ง
          .toList();

      results.addAll(records);
    }

    print("📥 Raw Records Found: ${results.length}");

    // Filter วันที่แบบละเอียด
    final filtered = results.where((r) {
      // ใช้ compareTo เพื่อความชัวร์ (Start <= Date <= End)
      // ผ่อนปรน Time นิดหน่อย
      return r.createdAt.compareTo(start) >= 0 &&
          r.createdAt.compareTo(end) <= 0;
    }).toList();

    // เรียงวันที่
    filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    print("✨ Final Filtered Records: ${filtered.length}");
    return filtered;
  }
}
