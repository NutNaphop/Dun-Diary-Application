import 'package:dun_diary_app/core/services/thai_name_generator_service.dart';
import 'package:dun_diary_app/core/recovery/recovery_flag_service.dart';
import 'package:flutter/material.dart';

import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:dun_diary_app/data/user/model/user_profile.dart';
import 'package:dun_diary_app/data/user/repository/user_repository.dart';
import 'package:dun_diary_app/shared/constant/app_image.dart';

class SplashViewModel extends ChangeNotifier {
  final AuthService _authService;
  final UserRepository _userRepository;

  SplashViewModel({
    required AuthService authService,
    required UserRepository userRepository,
  }) : _authService = authService,
       _userRepository = userRepository;

  bool _isRecoveryPending = false;
  bool get isRecoveryPending => _isRecoveryPending;

  Future<void> initializeAppData() async {
    try {
      await _authService.initializeUserIdentity();
      final uid = await _authService.getUserIdForSaving();

      final localUser = _userRepository.getLocalUser();

      if (localUser == null && uid.isNotEmpty) {
        AppLogger.info("🆕 First time open: Creating default profile...");

        final defaultProfile = UserProfile(
          uid: uid,
          displayName: await ThaiNameGenerator.generate(),
          photoUrl: AppImages.profile.extractFileName(
            AppImages.profile.avatar1,
          ),
          createdAt: DateTime.now(),
          isSynced: false,
        );

        await _userRepository.updateUserProfile(defaultProfile, false);
      } else {
        AppLogger.info("✅ Local profile ready: ${localUser?.displayName}");
      }
    } catch (e, stackTrace) {
      AppLogger.error("❌ Init App Data Error: $e", stackTrace);
    }

    // เช็คว่ามี recovery ค้างอยู่หรือไม่
    _isRecoveryPending = RecoveryFlagService.isRecoveryPending();
    if (_isRecoveryPending) {
      AppLogger.warning("⚠️ Detected interrupted recovery!");
    }
  }
}
