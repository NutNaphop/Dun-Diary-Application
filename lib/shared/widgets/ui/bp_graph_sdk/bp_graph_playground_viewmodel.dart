import 'package:dun_diary_app/shared/constant/app_bp_level.dart';
import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/models/blood_pressure_graph_models.dart';
import 'package:flutter/material.dart';

enum GraphFilterType {
  time,
  week,
  month,
  year,
  empty,
  emptyWeek,
  emptyMonth,
  emptyYear;

  String? get label {
    switch (this) {
      case GraphFilterType.time:
        return "ข้อมูลรายชั่วโมง";
      case GraphFilterType.empty:
        return null;
      case GraphFilterType.emptyWeek || week:
        return "สัปดาห์";
      case GraphFilterType.emptyMonth || month:
        return "เดือน";
      case GraphFilterType.emptyYear || year:
        return "ปี";
    }
  }
}

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

  void navigationToRecord() {
    NavigationService.instance.pushNamed(AppRoutes.record);
  }

  List<BloodPressureGraphData> getMockData() {
    return List.generate(7, (index) {
      final levels = [
        BPLevel.normal,
        BPLevel.elevated,
        BPLevel.normal,
        BPLevel.elevated,
        BPLevel.normal,
        BPLevel.elevated,
        BPLevel.normal,
      ];
      return BloodPressureGraphData(
        xLabel: '',
        level: levels[index % levels.length],
        sourceData: 'mock',
      );
    });
  }

  List<BloodPressureGraphData> get currentData {
    switch (_selectedFilter) {
      case GraphFilterType.time:
        return [
          BloodPressureGraphData(
            xLabel: '08:00',
            level: BPLevel.low,
            sourceData: 'T1',
          ),
          BloodPressureGraphData(
            xLabel: '09:00',
            level: BPLevel.normal,
            sourceData: 'T2',
          ),
          BloodPressureGraphData(
            xLabel: '10:00',
            level: BPLevel.elevated,
            sourceData: 'T3',
          ),
          BloodPressureGraphData(
            xLabel: '11:00',
            level: BPLevel.highStage1,
            sourceData: 'T4',
          ),
          BloodPressureGraphData(
            xLabel: '12:00',
            level: BPLevel.highStage2,
            sourceData: 'T5',
          ),
          BloodPressureGraphData(
            xLabel: '13:00',
            level: BPLevel.crisis,
            sourceData: 'T6',
          ),
        ];
      case GraphFilterType.week:
        return List.generate(7, (index) {
          final levels = BPLevel.values;
          return BloodPressureGraphData(
            xLabel: '${index + 1}',
            level: levels[index % levels.length],
            sourceData: 'D${index + 1}',
          );
        });
      case GraphFilterType.month:
        final weeks = ['1-7', '8-14', '15-21', '22-28', '29-31', '1-7'];
        return List.generate(6, (index) {
          return BloodPressureGraphData(
            xLabel: weeks[index],
            level: BPLevel.values[index % 6],
            sourceData: 'W${index + 1}',
          );
        });
      case GraphFilterType.year:
        final months = [
          'ม.ค.',
          'ก.พ.',
          'มี.ค.',
          'เม.ย.',
          'พ.ค.',
          'มิ.ย.',
          'ก.ค.',
          'ส.ค.',
          'ก.ย.',
          'ต.ค.',
          'พ.ย.',
          'ธ.ค.',
        ];
        return List.generate(12, (index) {
          return BloodPressureGraphData(
            xLabel: months[index],
            level: BPLevel.values[index % 6],
            sourceData: 'M${index + 1}',
          );
        });
      case GraphFilterType.empty:
        return [];
      case GraphFilterType.emptyWeek:
        return [];
      case GraphFilterType.emptyMonth:
        return [];
      case GraphFilterType.emptyYear:
        return [];
    }
  }
}
