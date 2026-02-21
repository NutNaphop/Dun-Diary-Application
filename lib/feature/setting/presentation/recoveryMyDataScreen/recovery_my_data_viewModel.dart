import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/core/recovery/qr_encryptor.dart';
import 'package:dun_diary_app/core/recovery/recovery_flag_service.dart';
import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:dun_diary_app/core/services/flushbar_service.dart';
import 'package:dun_diary_app/core/services/media_service.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/data/user/model/user_profile.dart';
import 'package:dun_diary_app/data/user/repository/user_repository.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class RecoveryMyDataViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? decryptedUid;
  UserProfile? recoveredUser;

  // Recovery progress state
  bool isRecovering = false;
  bool isResumeError = false;
  String recoveryStatus = "";
  double recoveryProgress = 0.0;

  final MediaService _mediaService;
  final UserRepository _userRepository;
  final AuthService _authService;
  final BloodPressureRepository _bpRepository;
  final NetworkInfo _networkInfo;

  RecoveryMyDataViewModel({
    required NetworkInfo networkInfo,
    required MediaService mediaService,
    required UserRepository userRepository,
    required AuthService authService,
    required BloodPressureRepository bpRepository,
  }) : _networkInfo = networkInfo,
       _mediaService = mediaService,
       _userRepository = userRepository,
       _authService = authService,
       _bpRepository = bpRepository;

  // ===========================================================================
  // QR Code Methods
  // ===========================================================================

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
        AppLogger.warning(AppStrings.setting.qrNotFoundInImage);
        FlushbarService.instance.showError(AppStrings.setting.invalidQrData);
        return;
      }

      final String? rawQrData = capture.barcodes.first.rawValue;
      if (rawQrData != null) {
        await _handleScannedUid(rawQrData);
      } else {
        AppLogger.warning(AppStrings.setting.qrNotFoundInImage);
        FlushbarService.instance.showError(AppStrings.setting.invalidQrData);
      }
    } catch (e) {
      AppLogger.error("Error picking/decoding image: $e");
      FlushbarService.instance.showError(AppStrings.setting.imageProcessError);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> processScannedQR(String rawQrData) async {
    try {
      isLoading = true;
      notifyListeners();

      await _handleScannedUid(rawQrData);
    } catch (e) {
      AppLogger.error("Error processing scanned QR: $e");
      FlushbarService.instance.showError(AppStrings.setting.qrProcessError);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _handleScannedUid(String rawQrData) async {
    final String? uid = QrEncryptorService.decryptData(rawQrData);

    if (uid != null && uid.isNotEmpty) {
      final currentUid = _authService.getCurrentActiveUid();
      if (uid == currentUid) {
        AppLogger.warning("❌ Trying to recover self account");
        FlushbarService.instance.showError(
          AppStrings.setting.selfRecoveryError,
        );
        return;
      }

      decryptedUid = uid;

      // เช็คอินเทอร์เน็ตก่อนดึงข้อมูล ป้องกัน error ลวงตาว่าไม่พบบัญชี
      if (!await _networkInfo.hasInternetAccess) {
        FlushbarService.instance.showError(
          AppStrings.setting.noInternetCannotFetch,
        );
        return;
      }

      final successFetch = await _fetchPreviewData(uid);
      if (!successFetch) {
        FlushbarService.instance.showError(AppStrings.setting.accountNotFound);
      }
    } else {
      AppLogger.warning(AppStrings.setting.decryptionFailed);
      FlushbarService.instance.showError(AppStrings.setting.invalidQrData);
    }
  }

  // ===========================================================================
  // Recovery Logic
  // ===========================================================================

  /// update progress state
  void _updateProgress(String status, double progress) {
    recoveryStatus = status;
    recoveryProgress = progress;
    notifyListeners();
  }

  /// resume recovery from pending flag
  Future<bool> resumeRecovery() async {
    final pendingUid = RecoveryFlagService.getPendingRecoveryUid();
    if (pendingUid == null) return false;

    decryptedUid = pendingUid;

    if (!await _networkInfo.hasInternetAccess) {
      FlushbarService.instance.showError(
        AppStrings.setting.noInternetCannotFetch,
      );
      isResumeError = true;
      notifyListeners();
      return false;
    }

    // fetch profile from remote
    final success = await _fetchPreviewData(pendingUid);
    if (!success) {
      if (!await _networkInfo.hasInternetAccess) {
        FlushbarService.instance.showError(
          AppStrings.setting.noInternetCannotFetch,
        );
        isResumeError = true;
        notifyListeners();
        return false;
      } else {
        // profile not found → consider recovery completed
        await RecoveryFlagService.clearRecoveryFlag();
        isResumeError = false;
        notifyListeners();
        return false;
      }
    }

    isResumeError = false;
    notifyListeners();
    // start recovery flow
    return confirmRecovery();
  }

  /// confirm recovery — Safe order: fetch → save → delete
  Future<bool> confirmRecovery() async {
    if (decryptedUid == null || recoveredUser == null) return false;

    // check internet connection
    if (!await _networkInfo.hasInternetAccess) {
      FlushbarService.instance.showError(AppStrings.setting.noInternetTryAgain);
      if (RecoveryFlagService.isRecoveryPending()) {
        isResumeError = true;
        notifyListeners();
      }
      return false;
    }

    try {
      isRecovering = true;
      isLoading = true;
      _updateProgress(AppStrings.setting.fetchingFromServer, 0.1);

      final currentUid = _authService.getCurrentActiveUid();

      // ====== STEP 1: fetch records from remote (store in memory) ======
      final records = await _bpRepository.fetchRecordsFromRemote(decryptedUid!);
      _updateProgress(AppStrings.setting.fetchSuccess(records.length), 0.2);

      // set recovery flag before destructive ops
      await RecoveryFlagService.setRecoveryFlag(decryptedUid!);

      // check if it's a resume run (if activeUid has changed, it means steps 2-3 have already been completed in the previous run)
      final isResumeRun = (currentUid == decryptedUid);

      if (!isResumeRun) {
        // clear all local data (only for first run)
        _updateProgress(AppStrings.setting.preparingSpace, 0.3);
        await _bpRepository.clearAllLocalData();

        // ====== STEP 3: set active UID ======
        _updateProgress(AppStrings.setting.settingUpAccount, 0.4);
        await _authService.setActiveUid(decryptedUid!);
      } else {
        AppLogger.info("🔄 SKIP PROFILE CONFIG");
      }

      // ====== STEP 4: save recovered profile to local ======
      _updateProgress(AppStrings.setting.savingProfile, 0.5);
      await _userRepository.saveRecoveredProfileToLocal(recoveredUser!);

      // ====== STEP 5: save records to local ======
      // count how many records already exist to update progress and skip steps
      int alreadySaved = 0;
      if (isResumeRun) {
        final localRecords = _bpRepository.getAllRecords();
        alreadySaved = localRecords.length;
        if (alreadySaved > records.length) {
          alreadySaved = records.length; // ป้องกันเกิน
        }
      }

      _updateProgress(
        AppStrings.setting.savingDataProgress(alreadySaved, records.length),
        0.5,
      );

      for (var i = 0; i < records.length; i++) {
        // save to Hive (.addRecord uses .put to overwrite existing data, so no need to delete first)
        await _bpRepository.saveRecoveredRecord(records[i]);

        // update progress only when index is greater than already saved, or every 10th record, or last record
        if (i >= alreadySaved || i % 10 == 0 || i == records.length - 1) {
          // calculate progress from 0.5 to 0.9
          final saveProgress = 0.5 + (0.4 * (i + 1) / records.length);
          _updateProgress(
            AppStrings.setting.savingDataProgress(i + 1, records.length),
            saveProgress,
          );
        }
      }

      // ====== STEP 6: delete remote data of old UID (after recovery completed) ======
      if (currentUid != null && currentUid != decryptedUid) {
        _updateProgress(AppStrings.setting.clearingOldData, 0.9);
        await _bpRepository.deleteAllRemoteRecords(currentUid);
        await _userRepository.deleteRemoteUserData(currentUid);
      }

      // delete recovery flag
      await RecoveryFlagService.clearRecoveryFlag();

      _updateProgress(AppStrings.setting.recoveryCompleted, 1.0);
      AppLogger.info("✅ Recovery completed successfully!");
      return true;
    } catch (e) {
      AppLogger.error("❌ Recovery failed: $e");
      FlushbarService.instance.showError(AppStrings.setting.recoveryFailed);

      if (RecoveryFlagService.isRecoveryPending()) {
        isResumeError = true;
      }
      return false;
    } finally {
      isRecovering = false;
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
