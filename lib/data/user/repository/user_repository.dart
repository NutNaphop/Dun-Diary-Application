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

      if (remoteUser != null) {
        // 2. If found in server -> save to local and return
        await _localDataSource.saveUser(remoteUser);
        return remoteUser;
      } else {
        // 3. If not found in server (new user) -> try to get from local
        return _localDataSource.getUser();
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
      await _remoteDataSource.saveUserProfile(user);
    } else {
      // TODO: ถ้าจะ Advance อาจต้องมี Queue สำหรับ Profile แต่งานนี้เอาแค่นี้ก่อนก็ได้ครับ
      AppLogger.debug("⚠️ Offline: Profile saved locally only.");
    }
  }

  // Get local user (for showing in Home quickly)
  UserProfile? getLocalUser() => _localDataSource.getUser();
}
