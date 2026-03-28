import 'package:dun_diary_app/data/blood_pressure/model/record_model.dart';
import 'package:dun_diary_app/shared/constant/app_bp_level.dart';
export 'package:dun_diary_app/shared/constant/app_bp_level.dart';

/// Utility class สำหรับจัดการข้อมูลความดันโลหิต
///
/// Blood Pressure Levels (6 levels based on AHA guidelines):
/// - Level 0 (Low): SYS < 90 หรือ DIA < 60
/// - Level 1 (Normal): SYS 90-119 และ DIA 60-79
/// - Level 2 (Elevated): SYS 120-129 และ DIA < 80
/// - Level 3 (High Stage 1): SYS 130-139 หรือ DIA 80-89
/// - Level 4 (High Stage 2): SYS 140-179 หรือ DIA 90-119
/// - Level 5 (Crisis): SYS >= 180 หรือ DIA >= 120
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/models/blood_pressure_graph_models.dart';

class BloodPressureUtils {
  /// แปลง List<BPRecord> เป็น List<BloodPressureGraphData> สำหรับกราฟ
  static List<BloodPressureGraphData> mapToGraphData(List<BPRecord> records) {
    return records.map((record) {
      final level = calculateBloodPressureLevel(record.sys, record.dia);
      final timeLabel =
          "${record.createdAt.hour.toString().padLeft(2, '0')}:${record.createdAt.minute.toString().padLeft(2, '0')}";

      return BloodPressureGraphData(
        xLabel: timeLabel,
        level: level,
        sourceData: record,
      );
    }).toList();
  }
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
  static BPLevel calculateBloodPressureLevel(int sys, int dia) {
    final sysLevel = _calculateSysLevel(sys);
    final diaLevel = _calculateDiaLevel(dia);

    // ใช้ค่าที่สูงกว่า (worst-case scenario)
    final level = sysLevel > diaLevel ? sysLevel : diaLevel;
    return BPLevel.fromIndex(level);
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
  // ✅ ย้ายไปอยู่ใน BPLevel enum แล้ว
  // ใช้ level.label, level.description, level.color, level.animation แทน

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

  static BPLevel calculateAVGLevel(List<BPLevel> levelList) {
    if (levelList.isEmpty) return BPLevel.normal; // default to normal

    // 🚨 Safety First: ถ้ามีค่าวิกฤต หรือ สูงมาก ให้ยึดค่านั้นทันที (ไม่เฉลี่ย)
    if (levelList.contains(BPLevel.crisis)) return BPLevel.crisis;
    if (levelList.contains(BPLevel.highStage2)) return BPLevel.highStage2;

    // ถ้าไม่มีอันตรายร้ายแรง ค่อยใช้ค่าเฉลี่ยตามปกติ
    int sumLevel = levelList.fold(0, (prev, element) => prev + element.index);
    return BPLevel.fromIndex((sumLevel / levelList.length).round());
  }

  /// คำนวณความเสี่ยงรวม (Safety First Strategy)
  /// ใช้สำหรับ Stat view โดยเฉพาะ
  /// 1. ถ้าเจอ Crisis ในช่วง -> Crisis
  /// 2. ถ้าเจอ High Stage 2 -> High Stage 2
  /// 3. ถ้าไม่มีตัวร้ายแรง -> ใช้ค่าเฉลี่ย
  /// คำนวณความเสี่ยงรวม (Safety First Strategy)
  ///
  /// [isStrict] - ถ้า true (default) จะใช้ Safety First (Crisis -> Crisis)
  ///              ถ้า false จะใช้ค่าเฉลี่ยปกติ (สำหรับ Monthly/Yearly Stats)
  static BPLevel calculateOverallRiskLevel(
    List<BPRecord> records, {
    bool isStrict = true,
  }) {
    if (records.isEmpty) return BPLevel.normal;

    // 🚨 Strict Mode (Safety First): สำหรับรายวัน หรือต้องการความเข้มงวด
    if (isStrict) {
      bool hasCrisis = false;
      bool hasHighStage2 = false;

      for (var r in records) {
        final level = calculateBloodPressureLevel(r.sys, r.dia);
        if (level == BPLevel.crisis) hasCrisis = true;
        if (level == BPLevel.highStage2) hasHighStage2 = true;
      }

      if (hasCrisis) return BPLevel.crisis;
      if (hasHighStage2) return BPLevel.highStage2;
    }

    // Default / Long Period: ใช้ค่าเฉลี่ยตามปกติ
    final avgSys = calculateAVGSYS(records.map((e) => e.sys).toList()).round();
    final avgDia = calculateAVGDIA(records.map((e) => e.dia).toList()).round();
    return calculateBloodPressureLevel(avgSys, avgDia);
  }
}
