/// Utility functions สำหรับคำนวณตำแหน่ง indicator บน Gauge
///
/// 6 ระดับ (0-5): low, normal, elevated, highStage1, highStage2, crisis
/// Alignment range: -1.0 (ซ้ายสุด) ถึง 1.0 (ขวาสุด)
/// แต่ละช่องกว้าง 2.0 / 6 ≈ 0.333
class GuageUtils {
  /// คำนวณตำแหน่งสำหรับ AVG Level line
  static double getAlignmentForAVGLevel(int level) {
    switch (level) {
      case 0:
        return -0.83;
      case 1:
        return -0.5;
      case 2:
        return -0.18;
      case 3:
        return 0.17;
      case 4:
        return 0.5;
      case 5:
        return 0.83;
      default:
        return 0.0;
    }
  }

  /// คำนวณตำแหน่งสำหรับ Star indicator
  static double getAlignmentForLevel(int level) {
    switch (level) {
      case 0:
        return -0.89;
      case 1:
        return -0.54;
      case 2:
        return -0.19;
      case 3:
        return 0.18;
      case 4:
        return 0.53;
      case 5:
        return 0.88;
      default:
        return 0.0;
    }
  }
}
