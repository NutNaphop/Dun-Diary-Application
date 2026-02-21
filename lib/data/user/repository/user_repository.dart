import 'package:dun_diary_app/core/services/app_logger.dart';

import '../datasource/user_local_data_source.dart';
import '../datasource/user_remote_data_source.dart';
import '../model/user_profile.dart';

class UserRepository {
  final UserLocalDataSource _localDataSource;
  final UserRemoteDataSource _remoteDataSource;

  UserRepository({
    required UserLocalDataSource localDataSource,
    required UserRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  // --------------------------------------------------------
  // 🟢 Load Profile Logic
  // --------------------------------------------------------
  Future<UserProfile?> fetchUserProfile(String uid) async {
    try {
      // 1. Fetch from server first
      final remoteUser = await _remoteDataSource.getUserProfile(uid);
      final localUser = _localDataSource.getUser();

      if (remoteUser != null) {
        // if local data is pending to sync , it's still new data use it
        if (localUser != null && !localUser.isSynced) {
          return localUser;
        }
        // 2. If found in server -> save to local and return
        await _localDataSource.saveUser(remoteUser);
        return remoteUser;
      } else {
        // 3. If not found in server (new user) -> try to get from local
        return localUser;
      }
    } catch (e) {
      // 4. If no internet/Error -> get from local to show
      AppLogger.error("⚠️ Fetch User Error (Offline?): $e");
      return _localDataSource.getUser();
    }
  }

  Future<UserProfile?> getRemoteProfileOnly(String uid) async {
    try {
      return await _remoteDataSource.getUserProfile(uid);
    } catch (e) {
      AppLogger.error("❌ Failed to fetch preview profile: $e");
      return null;
    }
  }

  // --------------------------------------------------------
  // 🔵 Save/Update Logic
  // --------------------------------------------------------
  Future<void> updateUserProfile(UserProfile user, bool isOnline) async {
    // 1. Save to local immediately
    await _localDataSource.saveUser(user);

    // 2. If online -> send to Firebase
    if (isOnline) {
      try {
        await _remoteDataSource.saveUserProfile(user);
        user.isSynced = true;
        await _localDataSource.saveUser(user);
        AppLogger.debug("✅ Profile saved successfully.");
      } catch (e) {
        user.isSynced = false;
        await _localDataSource.saveUser(user);
        AppLogger.error("❌ Profile save failed: $e");
      }
    } else {
      user.isSynced = false;
      await _localDataSource.saveUser(user);
      AppLogger.debug("⚠️ Offline: Profile saved locally only.");
    }
  }

  Future<void> syncPendingProfile(String remoteUid) async {
    final user = _localDataSource.getUser();

    if (user != null) {
      // กรณี 1: UID ไม่ตรงกัน (เช่น Local=UUID, Remote=FirebaseUID)
      // ต้อง Migrate ข้อมูลไปใช้ UID จริง
      if (user.uid != remoteUid) {
        AppLogger.info(
          "🔀 Migrating user profile from ${user.uid} -> $remoteUid",
        );

        // สร้าง Profile ใหม่ด้วย ID จริง (Copy ข้อมูลเดิมมา)
        final migratedUser = UserProfile(
          uid: remoteUid,
          displayName: user.displayName,
          photoUrl: user.photoUrl,
          createdAt: user.createdAt,
          isSynced: true, // เดี๋ยวจะ save ลง Remote ต่อไป
        );

        try {
          // 1. Save to Remote first
          await _remoteDataSource.saveUserProfile(migratedUser);
          // 2. Save to Local
          await _localDataSource.saveUser(migratedUser);
          AppLogger.debug("✅ Migrated & Synced profile successfully!");
        } catch (e) {
          AppLogger.error("❌ Failed to migrate profile: $e");
        }
        return;
      }

      // กรณี 2: UID ตรงกันแต่ status = not synced
      if (!user.isSynced) {
        AppLogger.debug("☁️ Found unsynced profile. Syncing to Firebase...");
        try {
          await _remoteDataSource.saveUserProfile(user);
          user.isSynced = true;
          await _localDataSource.saveUser(user);
          AppLogger.debug("✅ Synced pending user profile successfully!");
        } catch (e) {
          AppLogger.error("❌ Failed to sync profile: $e");
        }
      } else {
        AppLogger.debug("✅ Profile is already up to date.");
      }
    }
  }

  Future<void> saveRecoveredProfileToLocal(UserProfile user) async {
    try {
      user.isSynced = true;
      await _localDataSource.saveUser(user);
      AppLogger.info("✅ Recovered profile saved to local successfully.");
    } catch (e) {
      AppLogger.error("❌ Failed to save recovered profile: $e");
      rethrow;
    }
  }

  /// ลบ remote user data (ใช้ตอน Recovery cleanup)
  Future<void> deleteRemoteUserData(String uid) async {
    try {
      await _remoteDataSource.deleteUserData(uid);
      AppLogger.info("🗑️ Deleted remote user data for $uid");
    } catch (e) {
      AppLogger.error("❌ Failed to delete remote user data: $e");
    }
  }

  // Get local user (for showing in Home quickly)
  UserProfile? getLocalUser() => _localDataSource.getUser();

  // Watch user changes
  Stream<void> watchUser() => _localDataSource.watchUser();
}
