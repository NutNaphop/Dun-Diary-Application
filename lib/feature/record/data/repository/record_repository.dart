import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../datasource/record_local_data_source.dart';
import '../../../home/data/model/bp_record.dart';

class RecordRepository {
  final RecordLocalDataSource _localDataSource;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        final docRef = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('records')
            .doc(record.id); // ใช้ ID เดียวกับ Local

        // ส่งขึ้น Cloud
        await docRef.set(record.toJson());

        // 3. ถ้าส่งผ่าน -> กลับมาติ๊กถูกในเครื่อง (Local)
        record.isSynced = true;
        await _localDataSource.updateRecord(record);
        
        print(" -> Synced record: ${record.id}");
      } catch (e) {
        print("❌ Failed to sync record ${record.id}: $e");
        // ถ้า error ก็ปล่อยไว้ (isSynced ยังเป็น false) รอบหน้าค่อยลองใหม่
      }
    }
  }
}