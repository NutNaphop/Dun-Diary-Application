import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/models/blood_pressure_graph_models.dart';
import 'package:flutter/material.dart';

enum GraphFilterType { time, day, week, month, empty }

class BpGraphPlaygroundViewModel extends ChangeNotifier {
  GraphFilterType _selectedFilter = GraphFilterType.month;
  GraphFilterType get selectedFilter => _selectedFilter;

  int _refreshCounter = 0;
  int get refreshCounter => _refreshCounter;

  void setFilter(GraphFilterType filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void replayAnimation() {
    _refreshCounter++;
    notifyListeners();
  }

  List<BloodPressureGraphData> get currentData {
    switch (_selectedFilter) {
      case GraphFilterType.time:
        return [
          BloodPressureGraphData(xLabel: '08:00', level: BloodPressureLevel.low, sourceData: 'T1'),
          BloodPressureGraphData(xLabel: '09:00', level: BloodPressureLevel.normal, sourceData: 'T2'),
          BloodPressureGraphData(xLabel: '10:00', level: BloodPressureLevel.preHigh, sourceData: 'T3'),
          BloodPressureGraphData(xLabel: '11:00', level: BloodPressureLevel.high, sourceData: 'T4'),
          BloodPressureGraphData(xLabel: '12:00', level: BloodPressureLevel.veryHigh, sourceData: 'T5'),
        ];
      case GraphFilterType.day:
        return List.generate(7, (index) {
          final levels = BloodPressureLevel.values;
          return BloodPressureGraphData(
            xLabel: '${index + 1}',
            level: levels[index % levels.length],
            sourceData: 'D${index + 1}',
          );
        });
      case GraphFilterType.week:
        final weeks = ['1-7', '8-14', '15-21', '22-28', '29-31', '1-7'];
        return List.generate(6, (index) {
          return BloodPressureGraphData(
            xLabel: weeks[index],
            level: BloodPressureLevel.values[index % 5],
            sourceData: 'W${index + 1}',
          );
        });
      case GraphFilterType.month:
        final months = ['ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];
        return List.generate(12, (index) {
          return BloodPressureGraphData(
            xLabel: months[index],
            level: BloodPressureLevel.values[index % 5],
            sourceData: 'M${index + 1}',
          );
        });
      case GraphFilterType.empty:
        return [];
    }
  }
}