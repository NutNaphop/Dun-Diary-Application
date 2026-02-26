import 'package:dun_diary_app/shared/constant/app_animations.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:flutter/painting.dart';

/// Blood Pressure Level Enum (6 levels based on AHA guidelines)
///
/// Level 0 - Low: SYS < 90 หรือ DIA < 60
/// Level 1 - Normal: SYS 90-119 และ DIA 60-79
/// Level 2 - Elevated: SYS 120-129 และ DIA < 80
/// Level 3 - High Stage 1: SYS 130-139 หรือ DIA 80-89
/// Level 4 - High Stage 2: SYS 140-179 หรือ DIA 90-119
/// Level 5 - Crisis: SYS >= 180 หรือ DIA >= 120
enum BPLevel {
  low,
  normal,
  elevated,
  highStage1,
  highStage2,
  crisis;

  /// แปลงจาก int index กลับเป็น enum
  static BPLevel fromIndex(int index) {
    if (index < 0 || index >= BPLevel.values.length) return BPLevel.normal;
    return BPLevel.values[index];
  }

  /// ตรวจสอบว่าเป็นระดับอันตรายหรือไม่ (>= highStage2)
  bool get isDangerous => index >= BPLevel.highStage2.index;

  String get label {
    switch (this) {
      case BPLevel.low:
        return AppStrings.bloodPressure.low;
      case BPLevel.normal:
        return AppStrings.bloodPressure.normal;
      case BPLevel.elevated:
        return AppStrings.bloodPressure.elevated;
      case BPLevel.highStage1:
        return AppStrings.bloodPressure.highStage1;
      case BPLevel.highStage2:
        return AppStrings.bloodPressure.highStage2;
      case BPLevel.crisis:
        return AppStrings.bloodPressure.crisis;
    }
  }

  String get description {
    switch (this) {
      case BPLevel.low:
        return AppStrings.bloodPressure.lowDesc;
      case BPLevel.normal:
        return AppStrings.bloodPressure.normalDesc;
      case BPLevel.elevated:
        return AppStrings.bloodPressure.elevatedDesc;
      case BPLevel.highStage1:
        return AppStrings.bloodPressure.highStage1Desc;
      case BPLevel.highStage2:
        return AppStrings.bloodPressure.highStage2Desc;
      case BPLevel.crisis:
        return AppStrings.bloodPressure.crisisDesc;
    }
  }

  Color get color {
    switch (this) {
      case BPLevel.low:
        return CustomColor.lowColor;
      case BPLevel.normal:
        return CustomColor.normalColor;
      case BPLevel.elevated:
        return CustomColor.elevatedColor;
      case BPLevel.highStage1:
        return CustomColor.highLevel1Color;
      case BPLevel.highStage2:
        return CustomColor.highLevel2Color;
      case BPLevel.crisis:
        return CustomColor.highLevel3CrisisColor;
    }
  }

  String get animation {
    switch (this) {
      case BPLevel.low:
        return AppAnimations.dizzyFace;
      case BPLevel.normal:
        return AppAnimations.blushing;
      case BPLevel.elevated:
        return AppAnimations.calm;
      case BPLevel.highStage1:
        return AppAnimations.grieved;
      case BPLevel.highStage2:
        return AppAnimations.sadTear;
      case BPLevel.crisis:
        return AppAnimations.error;
    }
  }
}
