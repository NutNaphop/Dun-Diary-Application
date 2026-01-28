import 'dart:io';

import 'package:dun_diary_app/core/services/flushbar_service.dart';
import 'package:dun_diary_app/core/services/model_service.dart';
import 'package:dun_diary_app/core/services/model_service.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/data/blood_pressure/model/result_model.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:dun_diary_app/shared/utils/bp_parser.dart';
import 'package:dun_diary_app/shared/utils/image_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ResultViewmodel extends ChangeNotifier {
  ResultViewmodel();

  List<BPFormat> _result = <BPFormat>[];
  List<BPFormat> get result => _result;

  String get sysValue => BPParser.getValueByType(_result, BPType.SYS);
  String get diaValue => BPParser.getValueByType(_result, BPType.DIA);
  String get pulValue => BPParser.getValueByType(_result, BPType.PUL);

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  bool _isAnalysisCompleted = false;
  bool get isAnalysisCompleted => _isAnalysisCompleted;

  @override
  void dispose() {
    super.dispose();
    ModelService.instance.dispose();
    _result.clear();
    _selectedImage = null;
  }

  Future<void> sendImageToModel(File image) async {
    try {
      // 1. อ่าน Bytes จากไฟล์
      final rawBytes = await image.readAsBytes();
      final fixedBytes = await compute(
        ImageUtils.processImageInIsolate,
        rawBytes,
      );

      final bytesToPredict = fixedBytes ?? rawBytes;
      final yoloPred = await ModelService.instance.predict(bytesToPredict);
      final res = BPParser.mapToYoloBoxResponse(yoloPred);
      _result = BPParser.parse(res);

      if (sysValue == "-" || diaValue == "-" || pulValue == "-") {
        FlushbarService.instance.showError(AppStrings.record.canNotReadImage);
      }
    } catch (e) {
      print("Error during model inference: $e");
      FlushbarService.instance.showError("เกิดข้อผิดพลาดในการวิเคราะห์รูปภาพ");
    } finally {
      _isAnalysisCompleted = true;
      notifyListeners();
    }
  }

  void setSelectImage(File img) {
    _selectedImage = img;
    notifyListeners();
  }

  void submitRecord() {
    final bp = BloodPressureUtils.parseStringToBloodPressure(
      sysValue,
      diaValue,
      pulValue,
    );
    NavigationService.instance.goBack(result: bp);
    notifyListeners();
  }

  Future<void> loadMockImage() async {
    try {
      final byteData = await rootBundle.load('assets/images/mock_bp.webp');

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/mock_bp.webp');

      await file.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
      );

      _selectedImage = file;
      notifyListeners();
    } catch (e) {
      print("Error loading mock image: $e");
    }
  }
}
