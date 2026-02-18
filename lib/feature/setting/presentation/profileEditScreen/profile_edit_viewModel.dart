import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:dun_diary_app/core/services/flushbar_service.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/data/user/model/user_profile.dart';
import 'package:dun_diary_app/data/user/repository/user_repository.dart';
import 'package:flutter/material.dart';

class ProfileEditViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  final AuthService _authService;
  final NetworkInfo _networkInfo;

  final TextEditingController nameController = TextEditingController();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _currentUid;
  DateTime _createdAt = DateTime.now();
  bool _isDisposed = false;

  ProfileEditViewModel({
    required UserRepository userRepository,
    required AuthService authService,
    required NetworkInfo networkInfo,
  }) : _userRepository = userRepository,
       _authService = authService,
       _networkInfo = networkInfo {
    _initData();
  }

  @override
  void dispose() {
    _isDisposed = true;
    nameController.dispose();
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void _initData() async {
    // _isLoading starts as true, so no need to notify immediately if called from constructor
    // verifying that we are not notifyListeners() synchronously during build

    try {
      _currentUid = await _authService.getUserIdForSaving();
      final userProfile = await _userRepository.fetchUserProfile(_currentUid!);

      if (userProfile != null) {
        nameController.text = userProfile.displayName;
        _createdAt = userProfile.createdAt;
      } else {
        nameController.text = "ผู้ใช้งานทั่วไป";
      }
    } catch (e, stackTrace) {
      AppLogger.error("Init Profile Error: $e", stackTrace);
      FlushbarService.instance.showError("โหลดข้อมูลไม่สำเร็จ");
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<void> saveProfile() async {
    final newName = nameController.text.trim();
    if (newName.isEmpty) {
      FlushbarService.instance.showWarning("กรุณากรอกชื่อ");
      return;
    }

    if (_isLoading) return;
    _isLoading = true;
    _safeNotifyListeners();

    try {
      final isOnline = await _networkInfo.isConnected;
      final updatedProfile = UserProfile(
        uid: _currentUid!,
        displayName: newName,
        createdAt: _createdAt,
        photoUrl: null, // เดี๋ยวค่อยมาทำเรื่องอัปรูป
      );

      await _userRepository.updateUserProfile(updatedProfile, isOnline);

      if (!_isDisposed) {
        FlushbarService.instance.showSuccess("บันทึกข้อมูลเรียบร้อย");
        NavigationService.instance.goBack();
      }
    } catch (e) {
      if (!_isDisposed) {
        AppLogger.error("❌ Save Profile Error: $e");
        FlushbarService.instance.showError("บันทึกไม่สำเร็จ");
        _isLoading = false;
        _safeNotifyListeners();
      }
    }
  }
}
