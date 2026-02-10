import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/utils/graph_config.dart';

/// Utility functions สำหรับคำนวณ coordinates ของกราฟ
class GraphUtils {
  /// คำนวณความกว้างของแต่ละ step (แนว X)
  ///
  /// ถ้ามีมากกว่า 1 จุด → แบ่งเท่าๆ กัน
  /// ถ้ามี 1 จุด → วางตรงกลาง
  static double getStepWidth(double graphWidth, int dataLength) {
    if (dataLength <= 1) {
      return graphWidth / 2;
    }
    return graphWidth / (dataLength - 1);
  }

  /// คำนวณความสูงของแต่ละ step (แนว Y)
  ///
  /// amountOfLine = 8 (2 baselines + 6 levels)
  /// แบ่งความสูงเป็น 7 ช่วง
  static double getStepHeight(double graphHeight) {
    return graphHeight / (GraphConfig.amountOfLine - 1);
  }

  /// คำนวณ X-coordinate จาก index
  static double getXCoordinate(int index, int dataLength, double stepWidth) {
    if (dataLength == 0) return 0;
    if (dataLength == 1) return stepWidth;
    return index * stepWidth;
  }

  /// คำนวณ Y-coordinate จาก level index (0-5)
  ///
  /// Level 0 (ต่ำ) อยู่ล่างสุด, Level 5 (วิกฤต) อยู่บนสุด
  static double getYCoordinate(
    int levelIndex,
    double graphHeight,
    double stepHeight,
  ) {
    return graphHeight - ((levelIndex + 1) * stepHeight);
  }
}
