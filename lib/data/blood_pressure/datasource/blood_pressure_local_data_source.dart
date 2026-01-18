import 'package:dun_diary_app/core/constant/hive_constants.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BloodPressureLocalDataSource {
  final Box<BPRecord> _box;

  BloodPressureLocalDataSource() : _box = Hive.box(HiveBoxName.bpRecord);

  Future<void> addRecord(BPRecord record) async {
    await _box.put(record.id, record);
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
}
