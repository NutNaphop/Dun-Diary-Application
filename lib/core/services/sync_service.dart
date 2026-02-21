import 'dart:async';

import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/data/user/repository/user_repository.dart';

/// Global Sync Service
///
/// ทำหน้าที่ดักฟัง connectivity แล้ว sync ข้อมูลที่ค้างอยู่ใน Queue
/// ขึ้น Firebase โดยอัตโนมัติ ทำงานตลอด lifecycle ของแอป
///
/// Flow:
/// 1. Listen onConnectivityChanged (event-driven, ไม่ poll)
/// 2. พอมีเน็ต → signInAnonymously (no-op ถ้า login แล้ว)
/// 3. เรียก syncAllPending() (no-op ถ้า queue ว่าง)
class SyncService {
  final NetworkInfo _networkInfo;
  final AuthService _authService;
  final BloodPressureRepository _repository;
  final UserRepository _userRepository;

  StreamSubscription? _connectivitySubscription;

  SyncService({
    required NetworkInfo networkInfo,
    required AuthService authService,
    required BloodPressureRepository repository,
    required UserRepository userRepository,
  }) : _networkInfo = networkInfo,
       _authService = authService,
       _repository = repository,
       _userRepository = userRepository {
    _startListening();
  }

  void _startListening() {
    _connectivitySubscription = _networkInfo.onConnectivityChanged.listen((
      _,
    ) async {
      final hasNet = await _networkInfo.isConnected;
      if (hasNet) {
        AppLogger.info("SyncService: Connected → starting sync flow...");

        // 1. ยืนยัน identity (signIn ถ้ายังไม่มี user)
        final user = await _authService.signInAnonymously();

        if (user != null) {
          // 2. Sync ข้อมูลที่ค้าง (ใช้ active UUID ไม่ใช่ Firebase UID)
          final activeUid = await _authService.getUserIdForSaving();
          await _repository.syncAllPending(activeUid);
          await _userRepository.syncPendingProfile(activeUid);
        }
      }
    });
    AppLogger.info("SyncService: Listening for connectivity changes.");
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    AppLogger.info("SyncService: Disposed.");
  }
}
