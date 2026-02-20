import 'package:dun_diary_app/core/recovery/qr_encryptor.dart';
import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:dun_diary_app/core/services/flushbar_service.dart';
import 'package:dun_diary_app/core/services/media_service.dart';
import 'package:dun_diary_app/data/user/model/user_profile.dart';
import 'package:dun_diary_app/data/user/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class RecoveryMyDataViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? decryptedUid;
  UserProfile? recoveredUser;

  final MediaService _mediaService;
  final UserRepository _userRepository;

  RecoveryMyDataViewModel({
    required MediaService mediaService,
    required UserRepository userRepository,
  }) : _mediaService = mediaService,
       _userRepository = userRepository;

  Future<void> pickImageAndDecodeQR() async {
    try {
      isLoading = true;
      notifyListeners();

      final image = await _mediaService.pickImage(source: ImageSource.gallery);

      if (image == null) {
        return;
      }

      final MobileScannerController controller = MobileScannerController(
        facing: CameraFacing.back,
      );
      final BarcodeCapture? capture = await controller.analyzeImage(image.path);

      if (capture == null || capture.barcodes.isEmpty) {
        AppLogger.warning("ไม่พบ QR code ในรูปภาพนี้");
        FlushbarService.instance.showError(
          "ไม่พบข้อมูล หรือ QR Code ไม่ถูกต้อง",
        );
        return;
      }

      final String? rawQrData = capture.barcodes.first.rawValue;
      if (rawQrData != null) {
        final String? uid = QrEncryptorService.decryptData(rawQrData);

        if (uid != null && uid.isNotEmpty) {
          decryptedUid = uid;
          final successFetch = await _fetchPreviewData(uid);
          if (!successFetch) {
            FlushbarService.instance.showError("ไม่พบข้อมูลบัญชีนี้ในระบบ");
          }
        } else {
          AppLogger.warning("ถอดรหัสล้มเหลว");
          FlushbarService.instance.showError(
            "ไม่พบข้อมูล หรือ QR Code ไม่ถูกต้อง",
          );
        }
      } else {
        AppLogger.warning("ไม่พบ QR code ในรูปภาพนี้");
        FlushbarService.instance.showError(
          "ไม่พบข้อมูล หรือ QR Code ไม่ถูกต้อง",
        );
      }
    } catch (e) {
      AppLogger.error("Error picking/decoding image: $e");
      FlushbarService.instance.showError("เกิดข้อผิดพลาดในการประมวลผลรูปภาพ");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> processScannedQR(String rawQrData) async {
    try {
      isLoading = true;
      notifyListeners();

      final String? uid = QrEncryptorService.decryptData(rawQrData);

      if (uid != null && uid.isNotEmpty) {
        decryptedUid = uid;
        final successFetch = await _fetchPreviewData(uid);
        if (!successFetch) {
          FlushbarService.instance.showError("ไม่พบข้อมูลบัญชีนี้ในระบบ");
        }
      } else {
        AppLogger.warning(
          "❌ ถอดรหัสล้มเหลว (อาจสแกน QR อื่นที่ไม่ใช่ของแอปเรา)",
        );
        FlushbarService.instance.showError(
          "ไม่พบข้อมูล หรือ QR Code ไม่ถูกต้อง",
        );
      }
    } catch (e) {
      AppLogger.error("Error processing scanned QR: $e");
      FlushbarService.instance.showError("เกิดข้อผิดพลาดในการประมวลผล QR Code");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> _fetchPreviewData(String uid) async {
    try {
      final user = await _userRepository.getRemoteProfileOnly(uid);
      if (user != null) {
        recoveredUser = user;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
