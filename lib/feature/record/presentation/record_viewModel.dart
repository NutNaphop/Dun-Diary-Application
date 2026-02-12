import 'dart:io';

import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/core/services/flushbar_service.dart';
import 'package:dun_diary_app/core/services/media_service.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/data/blood_pressure/model/record_model.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class RecordViewmodel extends ChangeNotifier {
  final BloodPressureRepository _repository;
  final AuthService _authService;
  final MediaService _mediaService;
  final NetworkInfo _networkInfo;

  RecordViewmodel({
    required BloodPressureRepository repository,
    required AuthService authService,
    required MediaService mediaService,
    required NetworkInfo networkInfo,
  }) : _repository = repository,
       _authService = authService,
       _mediaService = mediaService,
       _networkInfo = networkInfo;

  BloodPressure _bpValue = BloodPressure(sys: 113, dia: 64, pul: 74);
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

  String? _editingRecordId;
  bool get isEditMode => _editingRecordId != null;

  bool _isReadOnly = false;
  bool get isReadOnly => _isReadOnly;
  bool get hasExistingData => _editingRecordId != null;

  void init(BPRecord? record) {
    if (record != null) {
      _editingRecordId = record.id;
      _bpValue = BloodPressure(
        sys: record.sys,
        dia: record.dia,
        pul: record.pulse,
      );
      _recordDate = record.createdAt;
      _isReadOnly = true;
    } else {
      _editingRecordId = null;
      _bpValue = BloodPressure(sys: 113, dia: 64, pul: 74);
      _recordDate = DateTime.now();
      _isReadOnly = false;
    }
    notifyListeners();
  }

  void enterEditMode() {
    _isReadOnly = false;
    notifyListeners();
  }

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

      if (isEditMode) {
        final updatedRecord = BPRecord(
          id: _editingRecordId!,
          ownerId: userId,
          sys: _bpValue.sys,
          dia: _bpValue.dia,
          pulse: _bpValue.pul,
          createdAt: _recordDate,
          isSynced: false,
          note: "",
        );

        await _repository.updateRecord(
          updatedRecord,
          await _networkInfo.isConnected,
        );
        _isReadOnly = true;
        _isLoading = false;
        FlushbarService.instance.showSuccess("แก้ไขข้อมูลเรียบร้อย");
        notifyListeners();
      } else {
        // 3. สร้าง Record Object
        final newRecord = BPRecord(
          id: const Uuid().v4(),
          ownerId: userId,
          sys: _bpValue.sys,
          dia: _bpValue.dia,
          pulse: _bpValue.pul,
          createdAt: _recordDate,
          isSynced: false,
          note: "",
        );

        // 4. Save record id into boxQueue
        await _repository.saveRecordIdToQueueBox(newRecord.id);

        // 5. Save record into Local storage
        await _repository.saveRecord(newRecord, await _networkInfo.isConnected);
        _isLoading = false;
        notifyListeners();
        NavigationService.instance.goBack(result: true);
      }
    } catch (e) {
      print("❌ ViewModel Save Error: $e");
      FlushbarService.instance.showError(AppStrings.record.errorRecord);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteRecord() async {
    if (_editingRecordId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.deleteRecord(
        _editingRecordId!,
        await _networkInfo.isConnected,
      );

      NavigationService.instance.goBack(result: true);
      FlushbarService.instance.showSuccess("ลบบันทึกเรียบร้อย");
    } catch (e) {
      print("Delete Error: $e");
      FlushbarService.instance.showError("ลบไม่สำเร็จ");
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
