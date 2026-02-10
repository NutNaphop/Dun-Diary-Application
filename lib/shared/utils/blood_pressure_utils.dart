import 'package:dun_diary_app/data/blood_pressure/model/record_model.dart';
import 'package:dun_diary_app/shared/constant/app_animations.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:flutter/painting.dart';

/// Utility class สำหรับจัดการข้อมูลความดันโลหิต
///
/// Blood Pressure Levels (6 levels based on AHA guidelines):
/// - Level 0 (Low): SYS < 90 หรือ DIA < 60
/// - Level 1 (Normal): SYS 90-119 และ DIA 60-79
/// - Level 2 (Elevated): SYS 120-129 และ DIA < 80
/// - Level 3 (High Stage 1): SYS 130-139 หรือ DIA 80-89
/// - Level 4 (High Stage 2): SYS 140-179 หรือ DIA 90-119
/// - Level 5 (Crisis): SYS >= 180 หรือ DIA >= 120
class BloodPressureUtils {
  // ===========================================================================
  // 📊 SECTION 1: Parsing Functions
  // ===========================================================================

  static BloodPressure parseStringToBloodPressure(
    String sys,
    String dia,
    String pul,
  ) {
    final parseSys = int.tryParse(sys) ?? 0;
    final parseDia = int.tryParse(dia) ?? 0;
    final parsePul = int.tryParse(pul) ?? 0;

    return BloodPressure(sys: parseSys, dia: parseDia, pul: parsePul);
  }

  static BloodPressure parseIntToBloodPressure(int sys, int dia, int pul) {
    return BloodPressure(sys: sys, dia: dia, pul: pul);
  }

  // ===========================================================================
  // 🎯 SECTION 2: Blood Pressure Level Calculation
  // ===========================================================================

  /// คำนวณระดับความดันโลหิต (0-5) จากค่า SYS และ DIA
  ///
  /// Algorithm:
  /// 1. คำนวณ sysLevel และ diaLevel แยกกัน
  /// 2. ใช้ค่าที่สูงกว่าเป็นผลลัพธ์ (worst-case)
  ///
  /// Returns: 0-5 (low, normal, elevated, highStage1, highStage2, crisis)
  static int calculateBloodPressureLevel(int sys, int dia) {
    final sysLevel = _calculateSysLevel(sys);
    final diaLevel = _calculateDiaLevel(dia);

    // ใช้ค่าที่สูงกว่า (worst-case scenario)
    return sysLevel > diaLevel ? sysLevel : diaLevel;
  }

  /// คำนวณระดับจาก SYS
  static int _calculateSysLevel(int sys) {
    if (sys >= 180) return 5; // Crisis
    if (sys >= 140) return 4; // High Stage 2
    if (sys >= 130) return 3; // High Stage 1
    if (sys >= 120) return 2; // Elevated
    if (sys >= 90) return 1; // Normal
    return 0; // Low
  }

  /// คำนวณระดับจาก DIA
  static int _calculateDiaLevel(int dia) {
    if (dia >= 120) return 5; // Crisis
    if (dia >= 90) return 4; // High Stage 2
    if (dia >= 80) return 3; // High Stage 1
    if (dia >= 60) return 1; // Normal (60-79 = normal, 80+ = high)
    return 0; // Low
  }

  // ===========================================================================
  // 🏷️ SECTION 3: Label, Color & Animation Mapping
  // ===========================================================================

  /// แปลง level (0-5) เป็น label ภาษาไทย
  static String mapLevelLabel(int? level) {
    if (level == null) return '-';
    switch (level) {
      case 0:
        return AppStrings.bloodPressure.low;
      case 1:
        return AppStrings.bloodPressure.normal;
      case 2:
        return AppStrings.bloodPressure.elevated;
      case 3:
        return AppStrings.bloodPressure.highStage1;
      case 4:
        return AppStrings.bloodPressure.highStage2;
      case 5:
        return AppStrings.bloodPressure.crisis;
      default:
        return '-';
    }
  }

  /// แปลง level (0-5) เป็นสี
  static Color mapLevelColor(int? level) {
    if (level == null) return CustomColor.gray500;
    switch (level) {
      case 0:
        return CustomColor.lowColor; // น้ำเงิน - ต่ำ
      case 1:
        return CustomColor.normalColor; // เขียว - ปกติ
      case 2:
        return CustomColor.elevatedColor; // เหลือง - สูง
      case 3:
        return CustomColor.highLevel1Color; // ส้ม - สูงระดับ 1
      case 4:
        return CustomColor.highLevel2Color; // แดงอ่อน - สูงระดับ 2
      case 5:
        return CustomColor.highLevel3CrisisColor; // แดงเข้ม - วิกฤต
      default:
        return CustomColor.lowColor;
    }
  }

  /// แปลง level (0-5) เป็น animation
  static String mapLevelAnimation(int? level) {
    if (level == null) return AppAnimations.empty;
    switch (level) {
      case 0:
        return AppAnimations.dizzyFace; // ต่ำ - ห่วงใย
      case 1:
        return AppAnimations.blushing; // ปกติ - ยิ้ม
      case 2:
        return AppAnimations.calm; // สูง - สงบ
      case 3:
        return AppAnimations.grieved; // สูงระดับ 1 - สงบ
      case 4:
        return AppAnimations.sadTear; // สูงระดับ 2 - ห่วงใย
      case 5:
        return AppAnimations.error; // วิกฤต - ห่วงใย
      default:
        return AppAnimations.calm;
    }
  }

  // ===========================================================================
  // 📈 SECTION 4: Average Calculations
  // ===========================================================================

  static double calculateAVGSYS(List<int> sysList) {
    if (sysList.isEmpty) return 0;
    int sumSys = sysList.fold(0, (prev, element) => prev + element);
    return sumSys / sysList.length;
  }

  static double calculateAVGDIA(List<int> diaList) {
    if (diaList.isEmpty) return 0;
    int sumDia = diaList.fold(0, (prev, element) => prev + element);
    return sumDia / diaList.length;
  }

  static double calculateAVGPUL(List<int> pulList) {
    if (pulList.isEmpty) return 0;
    int sumPul = pulList.fold(0, (prev, element) => prev + element);
    return sumPul / pulList.length;
  }

  static int calculateAVGLevel(List<int> levelList) {
    if (levelList.isEmpty) return 1; // default to normal
    int sumLevel = levelList.fold(0, (prev, element) => prev + element);
    return (sumLevel / levelList.length).round();
  }
}
