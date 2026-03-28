import 'dart:async';

import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:dun_diary_app/data/user/model/user_profile.dart';
import 'package:dun_diary_app/data/user/repository/user_repository.dart';
import 'package:flutter/material.dart';

class GlobalUserProvider extends ChangeNotifier {
  final UserRepository _userRepository;

  UserProfile? _user;
  UserProfile? get user => _user;

  String get displayName => _user?.displayName ?? "ผู้ใช้งานทั่วไป";

  StreamSubscription? _subscription;

  GlobalUserProvider({required UserRepository userRepository})
    : _userRepository = userRepository {
    _init();
  }

  void _init() {
    // 1. Load initial data
    _user = _userRepository.getLocalUser();
    AppLogger.debug(
      "GlobalUserProvider: Initial user loaded -> ${_user?.displayName}",
    );
    notifyListeners();

    // 2. Listen to changes
    _subscription = _userRepository.watchUser().listen((_) {
      AppLogger.debug("GlobalUserProvider: User data changed, refreshing...");
      _refreshUser();
    });
  }

  void _refreshUser() {
    _user = _userRepository.getLocalUser();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
