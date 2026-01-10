import 'dart:async';

import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/mixins/record_navigation_mixin.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/core/services/dialog_service.dart';
import 'package:dun_diary_app/core/services/flushbar_service.dart';
import 'package:dun_diary_app/core/services/snackbar_service.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:flutter/material.dart';

class HomeViewmodel extends ChangeNotifier with RecordNavigationMixin {
  final BloodPressureRepository _recordRepo;
  final AuthService _authService;
  final NetworkInfo _networkInfo;

  StreamSubscription? _netSubscription; // ตัวดักฟัง
  StreamSubscription? _dbSubscription;

  HomeViewmodel({
    required BloodPressureRepository recordRepo,
    required AuthService authService,
    required NetworkInfo networkInfo,
  }) : _recordRepo = recordRepo,
       _authService = authService,
       _networkInfo = networkInfo {
    _startAutoDetect();
    _initData();
  }

  
  BPRecord? _latestRecord;
  BPRecord? get latestRecord => _latestRecord;

  bool _hasRecords = false;
  bool get hasRecords => _hasRecords;

  @override
  void dispose() {
    _netSubscription?.cancel();
    _dbSubscription?.cancel();
    super.dispose();
  }

  void _startAutoDetect() {
    _netSubscription = _networkInfo.onConnectivityChanged.listen((
      results,
    ) async {
      // ถ้ามีเน็ตทางใดทางหนึ่ง
      final hasNet = await _networkInfo.isConnected;
      _authService.initializeUserIdentity();
      if (hasNet) {
        print("📶 Internet Connected! Checking status...");

        // Step 1: ลอง Login (ถ้ายังไม่ได้ Login)
        // (signInAnonymously ฉลาดพอที่จะไม่ Login ซ้ำถ้ามี User อยู่แล้ว แต่เพื่อความชัวร์เช็คก่อนก็ได้)
        await _authService.signInAnonymously();

        // Step 2: สั่ง Migrate (Repo จะเช็คเองว่ามีข้อมูลต้องย้ายไหม)
        // await _repository.migrateData();
        await _recordRepo.syncAllPending();
      } else {}
    });
  }

  void toggleHasRecord() {
    _hasRecords = !_hasRecords;
    print(_hasRecords);
    notifyListeners();
  }

  void _initData() {
    _updateLatestRecord();
    // ดักฟังการเปลี่ยนแปลงข้อมูล (Add/Update/Delete) แล้วอัปเดตหน้าจอทันที
    _dbSubscription = _recordRepo.watchRecords().listen((_) {
      _updateLatestRecord();
    });
  }

  void _updateLatestRecord() {
    _latestRecord = _recordRepo.getLatestRecord();
    _hasRecords = _latestRecord != null;
    notifyListeners();
  }

  void showSnackBar() {
    SnackBarService.instance.showWarning("Hello");
  }

  void showDialog() {
    DialogService.instance.showConfirm("Hello", "World");
  }

  void showFlushbar(BuildContext context) {
    FlushbarService.instance.showError("Got Error", context: context);
  }
  
  // Debug function delete local storage data
  void deleteLocalData() {
    _recordRepo.deleteAllLocalData();
  }
}
