import 'package:dun_diary_app/core/constant/hive_constants.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/feature/home/data/datasource/user_local_data_source.dart';
import 'package:dun_diary_app/feature/home/data/datasource/user_remote_data_source.dart';
import 'package:dun_diary_app/feature/home/data/model/user.dart';
import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:hive_flutter/hive_flutter.dart';

class UserRepository {
  final AuthService _authService;
  final NetworkInfo _networkInfo;

  final UserLocalDataSource _localDataSource;
  final UserRemoteDataSource _remoteDataSource;

  UserRepository({
    required AuthService authService,
    required NetworkInfo networkInfo,
    required UserLocalDataSource localDataSource,
    required UserRemoteDataSource remoteDataSource,
  }) : _authService = authService,
       _networkInfo = networkInfo,
       _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  Future<List<User>> getUsers() async {
    final localUsers = _localDataSource.getAllUsers();
    try {
  
      final response = await _remoteDataSource.fetchUserFromAPI();
      final remoteUsers = (response)
          .take(2)
          .map((e) => User.fromJson(e))
          .toList();
      return [...localUsers, ...remoteUsers];
    } catch (e) {
      if (localUsers.isNotEmpty) return localUsers;
      rethrow;
    }
  }

  Future<void> createUser(String title) async {
    final ownerId = await _authService.getUserIdForSaving();
    final recordId = DateTime.now().millisecondsSinceEpoch;

    final newUser = User(
      id: recordId,
      ownerId: ownerId,
      title: title,
      image: 'default_image.png', // ใส่ค่า Default ไปก่อน
      profile: 'default_profile.png', // ใส่ค่า Default ไปก่อน
      isSynced: false, // เริ่มต้นคือยังไม่ส่ง
    );

    // 1. บันทึกลง Hive ทันที (Offline First)
    await _localDataSource.cacheUser(newUser);

    if (await _networkInfo.isConnected) {
      await syncAllPending();
    }
  }


Future<void> syncAllPending() async {
    if (await _networkInfo.isConnected == false) return;

    // 1. ขอรายการค้างจาก Local
    final pendingUsers = _localDataSource.getUnsyncedUsers();
    
    for (var user in pendingUsers) {
      try {
        // 2. สั่ง Remote ให้ส่ง
        await _remoteDataSource.uploadUser(user);
        
        // 3. สั่ง Local ให้อัปเดตสถานะ
        user.isSynced = true;
        await _localDataSource.updateUser(user);
        
        print("✅ Synced: ${user.title}");
      } catch (e) {
        print("❌ Sync Error: $e");
      }
    }
  }

  // 🔥 ฟังก์ชันย้ายร่าง (Migration)
  Future<void> migrateData() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    // หา UUID เก่า
    final settingsBox = Hive.box(HiveBoxName.settingsBox);
    final localUuid = settingsBox.get('local_uuid');

    if (localUuid != null) {
      print("🚀 Migrating from $localUuid to ${firebaseUser.uid}...");

      // หาข้อมูลของ UUID เก่า
      final oldData = _localDataSource.getUsersByOwnerId(localUuid);

      for (var item in oldData) {
        item.ownerId = firebaseUser.uid; // เปลี่ยนเจ้าของ
        item.isSynced = false; // สั่งให้ Sync ใหม่
        await item.save();
      }

      // ลบ UUID เก่าทิ้ง
      await settingsBox.delete('local_uuid');

      // Sync ข้อมูลที่เพิ่งแก้ขึ้น Cloud
      await syncAllPending();
    }
  }
}
