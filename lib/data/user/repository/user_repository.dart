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

  Future<void> syncPendingProfile() async {
    final user = _localDataSource.getUser();

    if (user != null && !user.isSynced) {
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

  // Get local user (for showing in Home quickly)
  UserProfile? getLocalUser() => _localDataSource.getUser();
}
