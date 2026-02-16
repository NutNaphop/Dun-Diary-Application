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

  /// 🔧 Debug Mode : Delete All Data
  Future<void> deleteAllRecords(String uid) async {
    try {
      final collection = _firestore
          .collection('users')
          .doc(uid)
          .collection('records');

      final snapshots = await collection.get();

      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }

      print("🔥 Firebase: All records deleted for user $uid");
    } catch (e) {
      print("❌ Firebase Clear Error: $e");
      rethrow;
    }
  }
}
