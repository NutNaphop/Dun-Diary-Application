import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:flutter/material.dart';

class ProfileEditViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();

  ProfileEditViewModel() {
    _initData();
  }

  void _initData() {
    // TODO: Fetch user data from repository/usecase
    nameController.text = "เอกพจน์"; // Mock data
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void saveProfile() {
    // TODO: Implement save logic
    AppLogger.debug("Saving name: ${nameController.text}");
  }
}
