import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/utils/graph_config.dart';

class GraphUtils {
  /// Calculates the step width for the graph based on the available width and number of data points.
  static double getStepWidth(double graphWidth, int dataLength) {
    if (dataLength <= 1) {
      return graphWidth / 2; // Handle single or no data point case
    }
    return graphWidth / (dataLength - 1);
  }

  /// Calculates the step height for the graph based on the available height.
  static double getStepHeight(double graphHeight) {
    return graphHeight / GraphConfig.amountOfLine;
  }

  /// Calculates the X-coordinate for a given index.
  static double getXCoordinate(int index, int dataLength, double stepWidth) {
    if (dataLength == 0) {
      return 0;
    }
    if (dataLength == 1) {
      return stepWidth ; // For a single point, place it in the middle
    }
    return index * stepWidth;
  }

  /// Calculates the Y-coordinate for a given blood pressure level index.
  static double getYCoordinate(int levelIndex, double graphHeight, double stepHeight) {
    return graphHeight - ((levelIndex + 1) * stepHeight);
  }
}
