import 'package:dun_diary_app/shared/constant/app_bp_level.dart';

class BloodPressureGraphData<T> {
  final String xLabel;
  final BPLevel level;
  final T sourceData;

  const BloodPressureGraphData({
    required this.xLabel,
    required this.level,
    required this.sourceData,
  });
}
