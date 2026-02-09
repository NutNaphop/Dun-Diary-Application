/// Model สำหรับ Summary Item ที่ส่งไป AI
///
/// ใช้แทน raw BPRecord เพื่อลด token usage
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
  final int level;

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
    'level': level,
  };
}

/// Model สำหรับ Summary รวมที่ส่งไป API
class AnalyzeSummary {
  final String periodType; // "week", "month", "year"
  final String rangeLabel;
  final List<AnalyzeSummaryItem> items;
  final int totalRecords;

  AnalyzeSummary({
    required this.periodType,
    required this.rangeLabel,
    required this.items,
    required this.totalRecords,
  });

  Map<String, dynamic> toJson() => {
    'periodType': periodType,
    'rangeLabel': rangeLabel,
    'totalRecords': totalRecords,
    'items': items.map((e) => e.toJson()).toList(),
  };
}
