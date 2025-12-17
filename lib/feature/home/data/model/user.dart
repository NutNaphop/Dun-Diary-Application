import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final String profile;

  @HiveField(4)
  bool isSynced;

  User({
    required this.id,
    required this.title,
    required this.image,
    required this.profile,
    this.isSynced = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      title: json['title'],
      image: json['url'],
      profile: json['thumbnailUrl'],
      isSynced: false
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'url': image, 'thumbnailUrl': profile};
  }
}
