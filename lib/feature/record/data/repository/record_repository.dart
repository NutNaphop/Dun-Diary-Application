import '../datasource/record_local_data_source.dart';
import '../../../home/data/model/bp_record.dart';

class RecordRepository {
  final RecordLocalDataSource _localDataSource;

  RecordRepository({required RecordLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  Future<void> saveRecord(BPRecord record) async {
    try {
      // 1. เก็บลงเครื่อง (Hive) ทันที -> เร็วปรู๊ด
      await _localDataSource.addRecord(record);
      
      print("✅ Repository: Saved locally. ID: ${record.id}");

      // 2. (อนาคต) ตรงนี้เราจะสั่ง Sync ขึ้น Firebase ต่อ
      // await _syncService.syncOne(record); 

    } catch (e) {
      print("❌ Save Error: $e");
      rethrow;
    }
  }

  List<BPRecord> getAllRecords() {
    return _localDataSource.getAllRecords();
  }
}