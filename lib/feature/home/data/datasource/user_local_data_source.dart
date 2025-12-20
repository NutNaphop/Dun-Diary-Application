import 'package:hive_flutter/hive_flutter.dart';
import '../model/user.dart';

class UserLocalDataSource {
  final Box<User> _userBox;

  UserLocalDataSource(this._userBox);

  // ดึงทั้งหมด
  List<User> getAllUsers() {
    return _userBox.values.toList();
  }

  // บันทึก/เพิ่ม
  Future<void> cacheUser(User user) async {
    await _userBox.add(user);
  }

  // อัปเดต (เช่น เปลี่ยนสถานะ sync)
  Future<void> updateUser(User user) async {
    await user.save();
  }

  // ดึงเฉพาะพวกที่ยังไม่ Sync
  List<User> getUnsyncedUsers() {
    return _userBox.values.where((u) => !u.isSynced).toList();
  }

  // ดึงตาม OwnerId (ใช้ตอน Migrate)
  List<User> getUsersByOwnerId(String ownerId) {
    return _userBox.values.where((u) => u.ownerId == ownerId).toList();
  }
}
