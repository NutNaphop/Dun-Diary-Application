import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dun_diary_app/core/constant/firebase_constants.dart';
import 'package:dun_diary_app/core/network/network_client.dart';
import '../model/user.dart';

class UserRemoteDataSource {
  final CollectionReference _firebaseRef;
  final NetworkClient _client;

  UserRemoteDataSource({
    required FirebaseFirestore firestore,
    required NetworkClient client,
  }) : _firebaseRef = firestore.collection(FirebaseConstants.usersCollection),
       _client = client;

  // ส่งข้อมูลขึ้น Cloud
  Future<void> uploadUser(User user) async {
    await _firebaseRef.doc(user.id.toString()).set(user.toJson());
  }

  Future<List> fetchUserFromAPI() async {
    final response = await _client.get('/photos');
    return response;
  }
}
