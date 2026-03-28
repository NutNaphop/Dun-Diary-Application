/// Model สำหรับ Summary Item ที่ส่งไป AI
///
/// ใช้แทน raw BPRecord เพื่อลด token usage
import 'package:dun_diary_app/shared/constant/app_bp_level.dart';

class AnalyzeSummaryItem {
  final String label;
  final int avgSys;
  final int avgDia;
  final int avgPulse;
  final int minSys;
  final int maxSys;
  final int minDia;
  final int maxDia;
  final int recordCount;
  final BPLevel level;

  AnalyzeSummaryItem({
    required this.label,
    required this.avgSys,
    required this.avgDia,
    required this.avgPulse,
    required this.minSys,
    required this.maxSys,
    required this.minDia,
    required this.maxDia,
    required this.recordCount,
    required this.level,
  });

  Map<String, dynamic> toJson() => {
    'label': label,
    'avgSys': avgSys,
    'avgDia': avgDia,
    'avgPulse': avgPulse,
    'minSys': minSys,
    'maxSys': maxSys,
    'minDia': minDia,
    'maxDia': maxDia,
    'count': recordCount,
    'level': level.index,
  };
}

/// ประเภทช่วงเวลาสำหรับการวิเคราะห์
enum PeriodType {
  week('week'),
  month('month'),
  year('year');

  final String value;
  const PeriodType(this.value);

  /// แปลง tabIndex เป็น PeriodType
  static PeriodType fromTabIndex(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return PeriodType.week;
      case 1:
        return PeriodType.month;
      case 2:
        return PeriodType.year;
      default:
        return PeriodType.week;
    }
  }
}

/// Model สำหรับ Summary รวมที่ส่งไป API
class AnalyzeSummary {
  final PeriodType periodType;
  final String rangeLabel;
  final List<AnalyzeSummaryItem> items;
  final int totalRecords;
  final double sd;

  AnalyzeSummary({
    required this.periodType,
    required this.rangeLabel,
    required this.items,
    required this.totalRecords,
    this.sd = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'periodType': periodType.value,
    'rangeLabel': rangeLabel,
    'totalRecords': totalRecords,
    'sd': sd,
    'items': items.map((e) => e.toJson()).toList(),
  };
}
