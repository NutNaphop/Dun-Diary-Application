import 'package:dun_diary_app/core/recovery/qr_generator.dart';
import 'package:dun_diary_app/core/services/export_service.dart';
import 'package:dun_diary_app/core/services/flushbar_service.dart';
import 'package:dun_diary_app/data/user/repository/user_repository.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:screenshot/screenshot.dart';

class MyQrCodeViewmodel extends ChangeNotifier {
  final UserRepository _userRepository;

  final ScreenshotController _screenshotController = ScreenshotController();
  ScreenshotController get screenshotController => _screenshotController;

  String qrData = "";
  bool isLoading = true;

  MyQrCodeViewmodel({required UserRepository userRepository})
    : _userRepository = userRepository {
    _generateQrData();
  }

  void _generateQrData() {
    final user = _userRepository.getLocalUser();

    if (user != null) {
      qrData = GenerateQrCodeService.generatePayload(user);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> snapImage() async {
    final image = await _screenshotController.capture(pixelRatio: 3.0);
    if (image != null) {
      try {
        await ExportService.instance.saveToGallery(image);
        FlushbarService.instance.showSuccess(
          AppStrings.history.saveImageSuccess,
        );
      } catch (e) {
        FlushbarService.instance.showError("บันทึกรูปลงเครื่องไม่สำเร็จ");
      }
    }
  }
}
