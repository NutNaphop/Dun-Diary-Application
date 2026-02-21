import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 4)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  String displayName;

  @HiveField(2)
  String? photoUrl;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  bool isSynced;

  UserProfile({
    required this.uid,
    required this.displayName,
    this.photoUrl,
    required this.createdAt,
    this.isSynced = true,
  });

  // แปลงจาก Firestore (JSON) -> Object
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] ?? '',
      displayName: json['displayName'] ?? 'ผู้ใช้งาน',
      photoUrl: json['photoUrl'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isSynced: true,
    );
  }

  // แปลงจาก Object -> Firestore (JSON)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
