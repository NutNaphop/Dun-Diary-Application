import 'package:dun_diary_app/data/analyze_record/model/analyze_summary_model.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';
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
    if (records.isEmpty) {
      return AnalyzeSummary(
        periodType: _getPeriodType(tabIndex),
        rangeLabel: rangeLabel,
        items: [],
        totalRecords: 0,
      );
    }

    // เรียงข้อมูลตามวันที่
    records.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    List<AnalyzeSummaryItem> items;
    if (tabIndex == 0) {
      items = _groupByDay(records);
    } else if (tabIndex == 1) {
      items = _groupByWeek(records);
    } else {
      items = _groupByMonth(records);
    }

    return AnalyzeSummary(
      periodType: _getPeriodType(tabIndex),
      rangeLabel: rangeLabel,
      items: items,
      totalRecords: records.length,
    );
  }

  // ===========================================================================
  // 📅 Grouping Methods
  // ===========================================================================

  /// Group by Day (สำหรับ Week view)
  static List<AnalyzeSummaryItem> _groupByDay(List<BPRecord> records) {
    final Map<String, List<BPRecord>> grouped = {};

    for (var r in records) {
      final key = DateFormat('d').format(r.createdAt);
      grouped.putIfAbsent(key, () => []).add(r);
    }

    return grouped.entries
        .map((e) => _createSummaryItem(e.key, e.value))
        .toList();
  }

  /// Group by Week (สำหรับ Month view)
  static List<AnalyzeSummaryItem> _groupByWeek(List<BPRecord> records) {
    final Map<String, List<BPRecord>> grouped = {};

    for (var r in records) {
      final weekStart = _getWeekStart(r.createdAt);
      final weekEnd = weekStart.add(const Duration(days: 6));
      final key = "${weekStart.day}-${weekEnd.day}";
      grouped.putIfAbsent(key, () => []).add(r);
    }

    // เรียงตามวันที่เริ่มต้นของสัปดาห์
    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) {
        final dayA = int.parse(a.key.split('-')[0]);
        final dayB = int.parse(b.key.split('-')[0]);
        return dayA.compareTo(dayB);
      });

    return sortedEntries
        .map((e) => _createSummaryItem(e.key, e.value))
        .toList();
  }

  /// Group by Month (สำหรับ Year view)
  static List<AnalyzeSummaryItem> _groupByMonth(List<BPRecord> records) {
    final Map<String, List<BPRecord>> grouped = {};

    for (var r in records) {
      final key = DateTimeUtils.getMonthShort(r.createdAt.month);
      grouped.putIfAbsent(key, () => []).add(r);
    }

    return grouped.entries
        .map((e) => _createSummaryItem(e.key, e.value))
        .toList();
  }

  // ===========================================================================
  // 🔧 Helper Methods
  // ===========================================================================

  /// สร้าง SummaryItem จาก records
  static AnalyzeSummaryItem _createSummaryItem(
    String label,
    List<BPRecord> records,
  ) {
    final sysList = records.map((e) => e.sys).toList();
    final diaList = records.map((e) => e.dia).toList();
    final pulseList = records.map((e) => e.pulse).toList();

    final avgSys = BloodPressureUtils.calculateAVGSYS(sysList).round();
    final avgDia = BloodPressureUtils.calculateAVGDIA(diaList).round();
    final avgPulse = (pulseList.reduce((a, b) => a + b) / pulseList.length)
        .round();

    return AnalyzeSummaryItem(
      label: label,
      avgSys: avgSys,
      avgDia: avgDia,
      avgPulse: avgPulse,
      minSys: sysList.reduce((a, b) => a < b ? a : b),
      maxSys: sysList.reduce((a, b) => a > b ? a : b),
      minDia: diaList.reduce((a, b) => a < b ? a : b),
      maxDia: diaList.reduce((a, b) => a > b ? a : b),
      recordCount: records.length,
      level: BloodPressureUtils.calculateBloodPressureLevel(avgSys, avgDia),
    );
  }

  /// หาวันจันทร์ของสัปดาห์
  static DateTime _getWeekStart(DateTime date) {
    final daysFromMonday = date.weekday - DateTime.monday;
    return DateTime(date.year, date.month, date.day - daysFromMonday);
  }

  /// แปลง tabIndex เป็น period type
  static String _getPeriodType(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 'week';
      case 1:
        return 'month';
      case 2:
        return 'year';
      default:
        return 'week';
    }
  }
}
