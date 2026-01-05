import 'dart:io';

import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/constant/app_routes.dart';
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

  RecordViewmodel({
    required BloodPressureRepository repository,
    required AuthService authService,
  }) : _repository = repository,
       _authService = authService;

  BloodPressure _bpValue = BloodPressure(sys: 120, dia: 80, pul: 70);
  BloodPressure get bpValue => _bpValue;

  DateTime _recordDate = DateTime.now();
  DateTime get recordDate => _recordDate;

  int get level => BloodPressureUtils.calculateBloodPressureLevel(
    _bpValue.sys,
    _bpValue.dia,
  );

  final MediaService _mediaService = MediaService();
  MediaService get mediaService => _mediaService;

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

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

  /// 💾 ฟังก์ชันกดปุ่มบันทึก
  Future<bool> saveResult() async {
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

      return true; // บันทึกสำเร็จ
    } catch (e) {
      print("❌ ViewModel Save Error: $e");
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
