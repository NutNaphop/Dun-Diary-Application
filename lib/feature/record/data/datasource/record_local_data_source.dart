import 'package:dun_diary_app/core/constant/hive_constants.dart';
import 'package:dun_diary_app/feature/home/data/model/bp_record.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RecordLocalDataSource {
  final Box<BPRecord> _box;

  RecordLocalDataSource() : _box = Hive.box(HiveBoxName.bpRecord);

  Future<void> addRecord(BPRecord record) async {
    await _box.add(record);
  }

  List<BPRecord> getAllRecords() {
    // เรียงจากใหม่ไปเก่า
    final list = _box.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }
  
  // ฟังก์ชันช่วยสำหรับ Sync
  List<BPRecord> getUnsyncedRecords() {
    return _box.values.where((r) => !r.isSynced).toList();
  }
  
}
