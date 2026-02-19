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
  UserProfile? _originalProfile;
  String? _selectedAvatarFileName;

  bool _isDisposed = false;

  ProfileEditViewModel({
    required UserRepository userRepository,
    required AuthService authService,
    required NetworkInfo networkInfo,
  }) : _userRepository = userRepository,
       _authService = authService,
       _networkInfo = networkInfo {
    nameController.addListener(_safeNotifyListeners);
    _initData();
  }

  @override
  void dispose() {
    _isDisposed = true;
    nameController.removeListener(_safeNotifyListeners);
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
      final localProfile = _userRepository.getLocalUser();

      if (localProfile != null) {
        _originalProfile = localProfile;
        nameController.text = localProfile.displayName;
        _isLoading = false;
        _safeNotifyListeners();
      }

      final remoteProfile = await _userRepository.fetchUserProfile(
        _currentUid!,
      );

      if (remoteProfile != null) {
        _originalProfile = remoteProfile;
        nameController.text = remoteProfile.displayName;
      } else if (localProfile == null) {
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

  void updateAvatar(String newAvatarFileName) {
    _selectedAvatarFileName = newAvatarFileName;
    _safeNotifyListeners();
  }

  Future<void> saveProfile() async {
    final newName = nameController.text.trim();
    if (newName.isEmpty) {
      FlushbarService.instance.showWarning("กรุณากรอกชื่อ");
      return;
    }

    if (!hasChanges) {
      FlushbarService.instance.showSuccess("บันทึกข้อมูลเรียบร้อย");
      NavigationService.instance.goBack();
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
        createdAt: _originalProfile?.createdAt ?? DateTime.now(),
        photoUrl: _selectedAvatarFileName ?? _originalProfile!.photoUrl,
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

  bool get hasChanges {
    if (_originalProfile == null) return true;
    if (nameController.text.trim() != _originalProfile!.displayName)
      return true;

    if (_selectedAvatarFileName != null &&
        _selectedAvatarFileName != _originalProfile!.photoUrl) {
      return true;
    }
    // IF MORE Field to edit just add here in this function

    return false;
  }
}
