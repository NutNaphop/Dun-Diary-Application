import 'package:dun_diary_app/shared/style/color.dart';
import 'package:flutter/widgets.dart';

/// Blood Pressure Level Enum (6 levels based on AHA guidelines)
///
/// Level 0 - Low: SYS < 90 หรือ DIA < 60
/// Level 1 - Normal: SYS 90-119 และ DIA 60-79
/// Level 2 - Elevated: SYS 120-129 และ DIA < 80
/// Level 3 - High Stage 1: SYS 130-139 หรือ DIA 80-89
/// Level 4 - High Stage 2: SYS 140-179 หรือ DIA 90-119
/// Level 5 - Crisis: SYS >= 180 หรือ DIA >= 120
enum BloodPressureLevel {
  low, // 0 - ต่ำ
  normal, // 1 - ปกติ
  elevated, // 2 - สูง (เดิมคือ preHigh)
  highStage1, // 3 - สูงระดับ 1
  highStage2, // 4 - สูงระดับ 2
  crisis; // 5 - วิกฤต

  String get label {
    switch (this) {
      case BloodPressureLevel.low:
        return 'ต่ำ';
      case BloodPressureLevel.normal:
        return 'ปกติ';
      case BloodPressureLevel.elevated:
        return 'สูง';
      case BloodPressureLevel.highStage1:
        return 'สูงระดับ 1';
      case BloodPressureLevel.highStage2:
        return 'สูงระดับ 2';
      case BloodPressureLevel.crisis:
        return 'วิกฤต';
    }
  }

  Color get color {
    switch (this) {
      case BloodPressureLevel.low:
        return CustomColor.lowColor; // น้ำเงิน - ต่ำกว่าปกติ
      case BloodPressureLevel.normal:
        return CustomColor.normalColor; // เขียว - ปกติ
      case BloodPressureLevel.elevated:
        return CustomColor.elevatedColor; // เหลือง - เริ่มสูง
      case BloodPressureLevel.highStage1:
        return CustomColor.highLevel1Color; // ส้ม - สูงระดับ 1
      case BloodPressureLevel.highStage2:
        return CustomColor.highLevel2Color; // แดงอ่อน - สูงระดับ 2
      case BloodPressureLevel.crisis:
        return CustomColor.highLevel3CrisisColor; // แดงเข้ม - วิกฤต
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
