import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dun_diary_app/core/services/app_logger.dart';
import '../model/bp_record.dart'; // import model ของคุณ

class BloodPressureRemoteDataSource {
  final FirebaseFirestore _firestore;

  // รับ firestore เข้ามา (Dependency Injection)
  BloodPressureRemoteDataSource({required FirebaseFirestore firestore})
    : _firestore = firestore;

  /// ส่งข้อมูล 1 รายการไป Firebase
  Future<void> saveRecordToFirebase(BPRecord record, String uid) async {
    try {
      // Path: users/{uid}/records/{record_id}
      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('records')
          .doc(record.id);

      // ส่งขึ้น Cloud
      await docRef.set(record.toJson());

      AppLogger.info("Firebase: Synced record ${record.id} success");
    } catch (e) {
      AppLogger.error("Firebase Error (ID: ${record.id})", e);
      rethrow; // โยน error กลับไปให้ Repository จัดการต่อ
    }
  }

  Future<void> deleteRecordFromFirebase(String recordId, String uid) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('records')
          .doc(recordId)
          .delete();
      AppLogger.info("Firebase: Deleted record $recordId success");
    } catch (e) {
      AppLogger.error("Firebase Delete Error", e);
      rethrow;
    }
  }

  /// ดึง records ทั้งหมดจาก Firebase (ใช้ตอน Recovery)
  Future<List<BPRecord>> fetchAllRecords(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('records')
          .get();
      return snapshot.docs.map((doc) => BPRecord.fromJson(doc.data())).toList();
    } catch (e) {
      AppLogger.error("Firebase: Failed to fetch all records", e);
      rethrow;
    }
  }

  /// ลบ records ทั้งหมดของ user (ใช้ Batch เพื่อความเร็ว, สูงสุด 500 docs/batch)
  Future<void> deleteAllRecords(String uid) async {
    try {
      final collection = _firestore
          .collection('users')
          .doc(uid)
          .collection('records');

      final snapshots = await collection.get();

      // Firestore batch limit = 500 operations
      const batchSize = 500;
      for (var i = 0; i < snapshots.docs.length; i += batchSize) {
        final batch = _firestore.batch();
        final chunk = snapshots.docs.skip(i).take(batchSize);
        for (var doc in chunk) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      }

      AppLogger.info(
        "🔥 Firebase: Batch deleted ${snapshots.docs.length} records for $uid",
      );
    } catch (e) {
      AppLogger.error("❌ Firebase Batch Delete Error: $e");
      rethrow;
    }
  }
}
