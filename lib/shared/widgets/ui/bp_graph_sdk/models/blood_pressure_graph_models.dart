import 'package:dun_diary_app/shared/style/color.dart';
import 'package:flutter/widgets.dart';

enum BloodPressureLevel {
  low,
  normal,
  preHigh,
  high,
  veryHigh;

  String get label {
    switch (this) {
      case BloodPressureLevel.low:
        return 'ต่ำ';
      case BloodPressureLevel.normal:
        return 'ปกติ';
      case BloodPressureLevel.preHigh:
        return 'เริ่มสูง';
      case BloodPressureLevel.high:
        return 'สูง';
      case BloodPressureLevel.veryHigh:
        return 'สูงมาก';
    }
  }

  Color get color {
    switch (this) {
      case BloodPressureLevel.low:
        return CustomColor.dangerColor;
      case BloodPressureLevel.normal:
        return CustomColor.successColor;
      case BloodPressureLevel.preHigh:
        return CustomColor.warningColor;
      case BloodPressureLevel.high:
        return CustomColor.quiteDangerColor;
      case BloodPressureLevel.veryHigh:
        return CustomColor.dangerColor;
    }
  }
}

class BloodPressureGraphData<T> {
  final String xLabel;
  final BloodPressureLevel level;
  final T sourceData;

  const BloodPressureGraphData({
    required this.xLabel,
    required this.level,
    required this.sourceData,
  });
}
