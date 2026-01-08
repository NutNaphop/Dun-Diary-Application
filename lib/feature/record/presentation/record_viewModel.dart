import 'dart:io';

import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/services/flushbar_service.dart';
import 'package:dun_diary_app/core/services/media_service.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/data/blood_pressure/model/record_model.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class RecordViewmodel extends ChangeNotifier {
  final BloodPressureRepository _repository;
  final AuthService _authService;
  final MediaService _mediaService;

  RecordViewmodel({
    required BloodPressureRepository repository,
    required AuthService authService,
    required MediaService mediaService,
  }) : _repository = repository,
       _authService = authService,
       _mediaService = mediaService;


  BloodPressure _bpValue = BloodPressure(sys: 120, dia: 80, pul: 70);
  BloodPressure get bpValue => _bpValue;

  DateTime _recordDate = DateTime.now();
  DateTime get recordDate => _recordDate;

  int get level => BloodPressureUtils.calculateBloodPressureLevel(
    _bpValue.sys,
    _bpValue.dia,
  );

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void updateSys(int value) {
    _bpValue.sys = value;
    notifyListeners();
  }

  void updateDia(int value) {
    _bpValue.dia = value;
    notifyListeners();
  }

  void updatePul(int value) {
    _bpValue.pul = value;
    notifyListeners();
  }

  void setBPValue(BloodPressure value) {
    _bpValue = value;
    notifyListeners();
  }

  void setRecordDate(DateTime value) {
    _recordDate = value;
    notifyListeners();
  }

  Future<void> handlePickImage(ImageSource source) async {
    final File? image = await _mediaService.pickImage(source: source);

    if (image != null) {
      _selectedImage = image;
      final result = await NavigationService.instance.pushNamed(
        AppRoutes.result,
        arguments: selectedImage,
      );

      if (result is BloodPressure) {
        setBPValue(result);
      }
    }

    notifyListeners();
  }

  Future<void> saveResult() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      // 2. หา Owner ID -> ได้ทันทีไม่ต้องรอเน็ต
      final userId = await _authService.getUserIdForSaving();

      // 3. สร้าง Record Object
      final newRecord = BPRecord(
        id: const Uuid().v4(),
        ownerId: userId,
        sys: _bpValue.sys,
        dia: _bpValue.dia,
        pulse: _bpValue.pul,
        createdAt: DateTime.now(),
        isSynced: false,
        note: "",
      );

      // 4. ส่งให้ Repo บันทึก
      await _repository.saveRecord(newRecord);
      NavigationService.instance.goBack(result: true);
    } catch (e) {
      print("❌ ViewModel Save Error: $e");
      FlushbarService.instance.showError("เกิดข้อผิดพลาดในการบันทึกข้อมูล");
      _isLoading = false;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
