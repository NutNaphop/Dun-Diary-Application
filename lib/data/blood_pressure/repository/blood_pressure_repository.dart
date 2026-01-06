import 'package:dun_diary_app/data/blood_pressure/datasource/blood_pressure_remote_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../datasource/blood_pressure_local_data_source.dart';
import '../model/bp_record.dart';

class BloodPressureRepository {
  final BloodPressureLocalDataSource _localDataSource;
  final BloodPressureRemoteDataSource _remoteDataSource;

  BloodPressureRepository({
    required BloodPressureLocalDataSource localDataSource,
    required BloodPressureRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  Future<void> saveRecord(BPRecord record) async {
    try {
      await _localDataSource.addRecord(record);
      print("✅ Repository: Saved locally. ID: ${record.id}");
      await syncAllPending();

    } catch (e) {
      print("❌ Save Error: $e");
      rethrow;
    }
  }

  List<BPRecord> getAllRecords() {
    return _localDataSource.getAllRecords();
  }

  Future<void> syncAllPending() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("🚫 Sync aborted: No User Logged in");
      return;
    }

    // 1. หาข้อมูลที่ยังค้างท่ออยู่
    final pendingRecords = _localDataSource.getUnsyncedRecords();
    if (pendingRecords.isEmpty) {
      print("✅ Sync: No pending records");
      return;
    }

    print("☁️ Syncing ${pendingRecords.length} records...");

    // 2. วนลูปส่งทีละตัว
    for (final record in pendingRecords) {
      try {
        // Path: users/{uid}/records/{record_id}
        await _remoteDataSource.saveRecordToFirebase(record, user.uid);

        // 3. ถ้าส่งผ่าน -> กลับมาติ๊กถูกในเครื่อง (Local)
        record.isSynced = true;
        await _localDataSource.updateRecord(record);

        print(" -> Synced record: ${record.id}");
      } catch (e) {
        print("❌ Failed to sync record ${record.id}: $e");
      }
    }
  }

  Stream<dynamic> watchRecords() {
    return _localDataSource.watchRecords();
  }
}
