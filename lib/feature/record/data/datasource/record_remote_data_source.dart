import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dun_diary_app/core/constant/firebase_constants.dart';
import 'package:dun_diary_app/core/network/network_client.dart';

class RecordRemoteDataSource {
  final CollectionReference _firebaseRef;
  final NetworkClient _client;

  RecordRemoteDataSource({
    required FirebaseFirestore firestore,
    required NetworkClient client,
  }) : _firebaseRef = firestore.collection(FirebaseConstants.recordsCollection),
       _client = client;

  
}
