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

  Future<void> saveRecord(BPRecord record, bool isOnline) async {
    try {
      await _localDataSource.addRecord(record);
      print("✅ Repository: Saved locally. ID: ${record.id}");

      if (isOnline) await syncAllPending();

      // Loop to show id in queuebox
      final remainingQueueIDs = _localDataSource.getAllRecordIdsInQueueBox();
      print(
        "✅ Sync completed. Remaining in QueueBox: ${remainingQueueIDs.length}",
      );
      for (final id in remainingQueueIDs) {
        print("   - $id");
      }
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

    // 1. Get into Queuebox
    final pendingQueueID = _localDataSource.getAllRecordIdsInQueueBox();

    if (pendingQueueID.isEmpty) {
      print("✅ Sync: No pending records");
      return;
    }

    print("☁️ Syncing ${pendingQueueID.length} records...");

    // 2. Loop through each ID and send to Firebase
    for (final recordID in pendingQueueID) {
      try {
        final record = _localDataSource.getRecordById(recordID);

        if (record == null) {
          print("⚠️ Record with ID $recordID not found locally. Skipping...");
          continue;
        }

        // Path: users/{uid}/records/{record_id}
        await _remoteDataSource.saveRecordToFirebase(record, user.uid);

        // 3. ถ้าส่งผ่าน -> กลับมาติ๊กถูกในเครื่อง (Local)
        record.isSynced = true;
        await _localDataSource.updateRecord(record);
        await _localDataSource.deleteRecordIdFromQueueBox(record.id);

        print(" -> Synced record: ${record.id}");
      } catch (e) {
        print("❌ Failed to sync record ${recordID}: $e");
      }
    }
  }

  // Get latest record
  BPRecord? getLatestRecord() {
    return _localDataSource.getLatestRecord();
  }

  Stream<dynamic> watchRecords() {
    return _localDataSource.watchRecords();
  }

  BPRecord? getLatestTodayRecord() {
    return _localDataSource.getLatestTodayRecord();
  }

  // Save id into Queuebox
  Future<void> saveRecordIdToQueueBox(String recordId) async {
    await _localDataSource.saveRecordIdToQueueBox(recordId);
  }

  // Debug function to delete all local data
  void deleteAllLocalData() {
    _localDataSource.getAllRecords().forEach((record) {
      record.delete();
    });
  }
}
