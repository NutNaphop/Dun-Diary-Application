import 'dart:math';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/feature/stat/model/stat_model.dart';

/// Utility class สำหรับคำนวณสถิติความดันโลหิต
///
/// คำนวณ:
/// - ค่าเฉลี่ย (Average SYS/DIA)
/// - ส่วนเบี่ยงเบนมาตรฐาน (Standard Deviation)
/// - ค่าสูงสุด/ต่ำสุด (Max/Min)
class StatUtils {
  /// คำนวณสถิติทั้งหมดจาก records
  ///
  /// [records] - รายการ BPRecord ที่จะคำนวณ
  ///
  /// Returns [StatCalulatedType] ที่มี:
  /// - avgBP: ค่าเฉลี่ยแบบ String "120 / 80"
  /// - avgSys, avgDia: ค่าเฉลี่ยแบบ int (สำหรับคำนวณ level)
  /// - sd: ส่วนเบี่ยงเบน "± 5.2"
  /// - maxBP, minBP: ค่าสูงสุด/ต่ำสุด + วันที่
  static StatCalulatedType calculate(List<BPRecord> records) {
    // กรณีไม่มีข้อมูล → return ค่าว่าง
    if (records.isEmpty) {
      final emptyValue = '- / -';
      return StatCalulatedType(
        avgBP: emptyValue,
        sd: emptyValue,
        maxBP: emptyValue,
        minBP: emptyValue,
      );
    }

    // คำนวณค่าพื้นฐาน
    final summary = computeBaseMetrics(records);
    final sd = calculateStandardDeviationError(records, summary.avgSys);

    return StatCalulatedType(
      avgBP: "${summary.avgSys} / ${summary.avgDia}",
      avgSys: summary.avgSys,
      avgDia: summary.avgDia,
      sd: "± ${sd.toStringAsFixed(1)}",
      isStable: isStandardDeviationStable(sd),
      maxBP: "${summary.max.sys} / ${summary.max.dia}",
      minBP: "${summary.min.sys} / ${summary.min.dia}",
      maxBPDate: summary.max.createdAt,
      minBPDate: summary.min.createdAt,
    );
  }

  static bool isStandardDeviationStable(double sd) => sd > 10;

  /// คำนวณค่าพื้นฐาน (avg, min, max) ด้วย single loop
  ///
  /// Time Complexity: O(n)
  static StatSummary computeBaseMetrics(List<BPRecord> records) {
    int sumSys = 0;
    int sumDia = 0;
    BPRecord min = records.first;
    BPRecord max = records.first;

    for (final r in records) {
      sumSys += r.sys;
      sumDia += r.dia;
      if (r.sys < min.sys) min = r;
      if (r.sys > max.sys) max = r;
    }

    return StatSummary(
      avgSys: (sumSys / records.length).round(),
      avgDia: (sumDia / records.length).round(),
      min: min,
      max: max,
    );
  }

  /// คำนวณ Standard Deviation (Population SD)
  ///
  /// Formula: σ = √(Σ(x - μ)² / N) / √N
  ///
  /// ใช้ SYS เป็นตัวแทนในการคำนวณ
  static double calculateStandardDeviationError(
    List<BPRecord> records,
    int avgSys,
  ) {
    if (records.length <= 1) return 0.0;

    double sumSquaredDiff = 0;
    for (final r in records) {
      sumSquaredDiff += pow(r.sys - avgSys, 2);
    }

    final sd = sqrt(sumSquaredDiff / records.length);
    return sd / sqrt(records.length);
  }

  // ===========================================================================
  // 🔢 Generic Helpers (ใช้ได้ทั่วโปรเจค)
  // ===========================================================================

  /// หาค่าต่ำสุดจาก List<int>
  static int minOf(List<int> values) {
    return values.reduce((a, b) => a < b ? a : b);
  }

  /// หาค่าสูงสุดจาก List<int>
  static int maxOf(List<int> values) {
    return values.reduce((a, b) => a > b ? a : b);
  }

  /// หาค่าเฉลี่ยจาก List<int>
  static int avgOf(List<int> values) {
    return (values.reduce((a, b) => a + b) / values.length).round();
  }
}
