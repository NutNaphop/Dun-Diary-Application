import 'dart:async';

import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:dun_diary_app/core/services/dialog_service.dart';
import 'package:dun_diary_app/core/services/flushbar_service.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/core/services/snackbar_service.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/shared/utils/mock_data_seeder.dart';
import 'package:flutter/material.dart';

class HomeViewmodel extends ChangeNotifier {
  final BloodPressureRepository _recordRepo;

  StreamSubscription? _dbSubscription;

  HomeViewmodel({required BloodPressureRepository recordRepo})
    : _recordRepo = recordRepo {
    _initData();
  }

  BPRecord? _latestRecord;
  BPRecord? get latestRecord => _latestRecord;

  bool _hasRecords = false;
  bool get hasRecords => _hasRecords;

  @override
  void dispose() {
    _dbSubscription?.cancel();
    super.dispose();
  }

  void toggleHasRecord() {
    _hasRecords = !_hasRecords;
    AppLogger.debug("hasRecords: $_hasRecords");
    notifyListeners();
  }

  void redirectToTutorial() {
    NavigationService.instance.pushNamed(AppRoutes.setting.tutorial);
    notifyListeners();
  }

  void redirectToRecord() {
    NavigationService.instance.pushNamed(AppRoutes.record);
  }

  void _initData() {
    _updateLatestRecord();
    _dbSubscription = _recordRepo.watchRecords().listen((_) {
      _updateLatestRecord();
    });
  }

  void _updateLatestRecord() {
    _latestRecord = _recordRepo.getLatestTodayRecord();
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
  void deleteLocalData() async {
    await _recordRepo.debugClearAllData(null);
  }

  Future<void> seedData() async {
    await MockDataSeeder(_recordRepo).generateBigData();
  }
}
