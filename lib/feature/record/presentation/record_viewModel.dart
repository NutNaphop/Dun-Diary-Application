import 'dart:io';

import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/services/media_service.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/feature/record/data/model/record_model.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RecordViewmodel extends ChangeNotifier {
  RecordViewmodel();

  BloodPressure _bpValue = BloodPressure(sys: 120, dia: 80, pul: 70);
  BloodPressure get bpValue => _bpValue;

  DateTime _recordDate = DateTime.now();
  DateTime get recordDate => _recordDate;

  int get level => BloodPressureUtils.calculateBloodPressureLevel(
    _bpValue.sys,
    _bpValue.dia,
  );

  MediaService _mediaService = MediaService();
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
      final result = await NavigationService.instance.pushNamed(AppRoutes.result, arguments: selectedImage);
      
      if (result is BloodPressure) {
        setBPValue(result);
      }
    }

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
