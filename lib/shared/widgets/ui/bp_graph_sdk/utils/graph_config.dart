/// Configuration constants สำหรับ Blood Pressure Graph
///
/// amountOfLine = 8 (2 baselines + 6 levels)
/// Structure: baseline(0) - 6 dashed levels - baseline(7)
class GraphConfig {
  static const double pointSize = 8;
  static const double halfPointSize = pointSize / 2;
  static const double amountOfLine = 8; // 2 baselines + 6 levels
  static const double yLabelWidth = 60; // เพิ่มจาก 40 เพื่อรองรับ "สูงระดับ 1"
  static const double yLabelWidthHalf = yLabelWidth / 2;
  static const double xLabelWidth = 20;
  static const double xLabelWidthHalf = xLabelWidth / 2;
  static const double dashWidth = 5.0;
  static const double dashSpace = 5.0;
}
