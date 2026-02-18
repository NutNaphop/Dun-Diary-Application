import 'package:dun_diary_app/core/constant/hive_constants.dart';
import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/user_profile.dart';

class UserLocalDataSource {
  final Box<UserProfile> _box;

  UserLocalDataSource() : _box = Hive.box(HiveBoxName.userBox);

  UserProfile? getUser() {
    if (_box.isEmpty) return null;
    return _box.getAt(0);
  }

  Future<void> saveUser(UserProfile user) async {
    await _box.clear();
    await _box.add(user);
    AppLogger.debug("✅ Local Save User Success");
  }

  Future<void> updateDisplayName(String newName) async {
    final user = getUser();
    if (user != null) {
      user.displayName = newName;
      await user.save();
    }
  }
}
