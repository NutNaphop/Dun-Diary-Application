class HiveBoxName {
  static const String settingsBox = 'settings';
  static const String bpRecord = "bpRecord";
  static const String QueueBox = "queueBox";
  static const String metaBox = "metaBox";
}

/// Keys ที่ใช้เก็บข้อมูลภายในแต่ละ Box
class HiveKeys {
  static const meta = _MetaKeys();
}

class _MetaKeys {
  const _MetaKeys();
  final String minYear = 'min_year';
  final String yearCounts = 'year_counts';
}