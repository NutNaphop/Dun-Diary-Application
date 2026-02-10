import 'package:dun_diary_app/data/analyze_record/model/analyze_summary_model.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';
import 'package:dun_diary_app/shared/utils/stat_utils.dart';
import 'package:intl/intl.dart';

/// Utility class สำหรับแปลง BPRecords เป็น Summary
///
/// ใช้ลด token usage โดยส่ง summarized data แทน raw records
class AnalyzeSummaryMapper {
  // ===========================================================================
  // 🎯 Main Entry Point
  // ===========================================================================

  /// แปลง BPRecords เป็น AnalyzeSummary ตาม tabIndex
  ///
  /// [records] - รายการ BPRecord
  /// [tabIndex] - 0 = Week (รายวัน), 1 = Month (รายสัปดาห์), 2 = Year (รายเดือน)
  /// [rangeLabel] - label แสดงช่วงเวลา เช่น "9 ก.พ. - 15 ก.พ. 2569"
  static AnalyzeSummary mapToSummary(
    List<BPRecord> records,
    int tabIndex,
    String rangeLabel,
  ) {
    final periodType = PeriodType.fromTabIndex(tabIndex);

    if (records.isEmpty) {
      return AnalyzeSummary(
        periodType: periodType,
        rangeLabel: rangeLabel,
        items: [],
        totalRecords: 0,
      );
    }

    // เรียงข้อมูลตามวันที่
    records.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final grouped = _groupRecords(records, periodType);

    final items = grouped.entries
        .map((e) => _createSummaryItem(e.key, e.value))
        .toList();

    return AnalyzeSummary(
      periodType: periodType,
      rangeLabel: rangeLabel,
      items: items,
      totalRecords: records.length,
    );
  }

  // ===========================================================================
  // 📅 Grouping Methods
  // ===========================================================================

  /// Group records ตาม PeriodType
  static Map<String, List<BPRecord>> _groupRecords(
    List<BPRecord> records,
    PeriodType periodType,
  ) {
    switch (periodType) {
      case PeriodType.week:
        return _groupByDay(records);
      case PeriodType.month:
        return _groupByWeek(records);
      case PeriodType.year:
        return _groupByMonth(records);
    }
  }

  /// Group by Day (สำหรับ Week view)
  static Map<String, List<BPRecord>> _groupByDay(List<BPRecord> records) {
    final Map<String, List<BPRecord>> grouped = {};
    for (var r in records) {
      final key = DateFormat('d').format(r.createdAt);
      grouped.putIfAbsent(key, () => []).add(r);
    }
    return grouped;
  }

  /// Group by Week (สำหรับ Month view)
  static Map<String, List<BPRecord>> _groupByWeek(List<BPRecord> records) {
    final Map<String, List<BPRecord>> grouped = {};
    for (var r in records) {
      final weekStart = _getWeekStart(r.createdAt);
      final weekEnd = weekStart.add(const Duration(days: 6));
      final key = "${weekStart.day}-${weekEnd.day}";
      grouped.putIfAbsent(key, () => []).add(r);
    }

    // เรียงตามวันที่เริ่มต้นของสัปดาห์
    final sorted = Map.fromEntries(
      grouped.entries.toList()..sort((a, b) {
        final dayA = int.parse(a.key.split('-')[0]);
        final dayB = int.parse(b.key.split('-')[0]);
        return dayA.compareTo(dayB);
      }),
    );
    return sorted;
  }

  /// Group by Month (สำหรับ Year view)
  static Map<String, List<BPRecord>> _groupByMonth(List<BPRecord> records) {
    final Map<String, List<BPRecord>> grouped = {};
    for (var r in records) {
      final key = DateTimeUtils.getMonthShort(r.createdAt.month);
      grouped.putIfAbsent(key, () => []).add(r);
    }
    return grouped;
  }

  // ===========================================================================
  // 🔧 Helper Methods
  // ===========================================================================

  /// สร้าง SummaryItem จาก records (ใช้ StatUtils สำหรับ min/max/avg)
  static AnalyzeSummaryItem _createSummaryItem(
    String label,
    List<BPRecord> records,
  ) {
    final sysList = records.map((e) => e.sys).toList();
    final diaList = records.map((e) => e.dia).toList();
    final pulseList = records.map((e) => e.pulse).toList();

    final avgSys = BloodPressureUtils.calculateAVGSYS(sysList).round();
    final avgDia = BloodPressureUtils.calculateAVGDIA(diaList).round();

    return AnalyzeSummaryItem(
      label: label,
      avgSys: avgSys,
      avgDia: avgDia,
      avgPulse: StatUtils.avgOf(pulseList),
      minSys: StatUtils.minOf(sysList),
      maxSys: StatUtils.maxOf(sysList),
      minDia: StatUtils.minOf(diaList),
      maxDia: StatUtils.maxOf(diaList),
      recordCount: records.length,
      level: BloodPressureUtils.calculateBloodPressureLevel(avgSys, avgDia),
    );
  }

  /// หาวันจันทร์ของสัปดาห์
  static DateTime _getWeekStart(DateTime date) {
    final daysFromMonday = date.weekday - DateTime.monday;
    return DateTime(date.year, date.month, date.day - daysFromMonday);
  }
}
