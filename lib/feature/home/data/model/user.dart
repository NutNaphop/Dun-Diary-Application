import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  int id; // ID ของข้อมูล (ใช้ Timestamp หรือ Auto Increment)

  @HiveField(1)
  String ownerId; // <--- สำคัญ! เก็บ UUID หรือ Firebase UID

  @HiveField(2)
  String title;

  @HiveField(3)
  String image;

  @HiveField(4)
  String profile;

  @HiveField(5)
  bool isSynced;

  User({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.image,
    required this.profile,
    this.isSynced = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      ownerId: '',
      title: json['title'],
      image: json['url'],
      profile: json['thumbnailUrl'],
      isSynced: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'ownerId': ownerId, 'title': title, 'url': image, 'thumbnailUrl': profile};
  }
}
