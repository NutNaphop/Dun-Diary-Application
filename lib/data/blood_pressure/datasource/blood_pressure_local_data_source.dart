import 'package:dun_diary_app/core/constant/hive_constants.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BloodPressureLocalDataSource {
  final Box<BPRecord> _box;

  BloodPressureLocalDataSource() : _box = Hive.box(HiveBoxName.bpRecord);

  Future<void> addRecord(BPRecord record) async {
    await _box.add(record);
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
    return _box.values.reduce((curr, next) => 
        curr.createdAt.compareTo(next.createdAt) > 0 ? curr : next
    );
  }

  // ฟังก์ชันช่วยสำหรับ Sync
  List<BPRecord> getUnsyncedRecords() {
    return _box.values.where((r) => !r.isSynced).toList();
  }
  
  // Update Status
  Future<void> updateRecord(BPRecord record) async {
    await record.save();
  }

  // Watch Record 
  Stream<dynamic> watchRecords() {
    return _box.watch();
  }
}
