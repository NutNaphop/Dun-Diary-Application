import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dun_diary_app/core/network/network_client.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';

class BloodPressureRemoteDataSource {
 final FirebaseFirestore _firestore ;
  BloodPressureRemoteDataSource({
    required FirebaseFirestore firestore,
    required NetworkClient client,
  }) : _firestore = FirebaseFirestore.instance;

  Future<void> saveRecordToFirebase(BPRecord pendingRecords, String uid) async {
    try {
      try {
        // Path: users/{uid}/records/{record_id}
        final docRef = _firestore
            .collection('users')
            .doc(uid)
            .collection('records')
            .doc(pendingRecords.id);

        // ส่งขึ้น Cloud
        await docRef.set(pendingRecords.toJson());
      } catch (e) {
        print("❌ Failed to sync record ${pendingRecords.id}: $e");
      }
    } catch (e) {
      print("❌ Firebase Error: $e");
      rethrow;
    }
  }
}
