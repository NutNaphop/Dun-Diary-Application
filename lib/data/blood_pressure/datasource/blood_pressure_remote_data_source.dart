import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/bp_record.dart'; // import model ของคุณ

class BloodPressureRemoteDataSource {
  final FirebaseFirestore _firestore;

  // รับ firestore เข้ามา (Dependency Injection)
  BloodPressureRemoteDataSource({
    required FirebaseFirestore firestore, 
  }) : _firestore = firestore;

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
      
      print("✅ Firebase: Synced record ${record.id} success");
      
    } catch (e) {
      print("❌ Firebase Error (ID: ${record.id}): $e");
      rethrow; // โยน error กลับไปให้ Repository จัดการต่อ
    }
  }
}