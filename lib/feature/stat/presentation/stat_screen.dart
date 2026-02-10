import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/data/analyze_record/model/analyze_result_model.dart';
import 'package:dun_diary_app/data/analyze_record/repository/analyze_repository.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/feature/stat/presentation/stat_viewModel.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/analyze_card/analyze_card.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/stat_card/stat_card.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/views/stat_summary_view.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/models/blood_pressure_graph_models.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/calendar_sdk.dart';
import 'package:dun_diary_app/shared/widgets/ui/tab_bar/app_tab_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => StatViewmodel(
        context.read<BloodPressureRepository>(),
        context.read<AnalyzeRepository>(),
        context.read<NetworkInfo>(),
      ),
      child: const StatScreen(),
    );
  }

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<StatViewmodel>();
    return CustomScaffold(
      appBar: MainAppBar(
        title: AppStrings.stat.stat,
        showBack: false,
        actions: [
          IconButtonSVG(
            path: AppIcons.outline.calendar,
            onPressed: () => _showCalendarDialog(context, viewModel),
          ),
          IconButtonSVG(
            path: AppIcons.outline.dotThree,
            onPressed: () => viewModel.seedData(),
          ),
        ],
      ),
      body: AppTabBar(
        onTap: (index) => viewModel.setTabIndex(index),
        titles: [
          AppStrings.calendar.week,
          AppStrings.calendar.month,
          AppStrings.calendar.year,
        ],
        // ใช้ StatSummaryView เดียว เพราะ ViewModel จัดการข้อมูลตาม tab อยู่แล้ว
        // ไม่ใช้ TabBarView เพราะทุก tab แสดง data เดียวกัน (ลด widget tree 3x → 1x)
        child: Selector<StatViewmodel, _StatSummaryData>(
          selector: (_, vm) => _StatSummaryData(
            dateLabel: vm.currentRangeLabel,
            analyzeState: vm.analyzeState,
            resultFromAi: vm.aiResultContent,
            bloodPressureLevel: vm.bloodPressureLevel,
            statsData: vm.statsData,
            graphData: vm.graphData,
            isInternetConnected: vm.isInternetConnected,
            isLoading: vm.isLoading,
          ),
          builder: (context, data, _) {
            if (data.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return StatSummaryView(
              dateLabel: data.dateLabel,
              analyzeState: data.analyzeState,
              resultFromAi: data.resultFromAi,
              bloodPressureLevel: data.bloodPressureLevel,
              data: data.statsData,
              graphData: data.graphData,
              isInternetConnected: data.isInternetConnected,
              onAnalyzePressed: viewModel.triggerAnalyze,
              onRecordPressed: viewModel.redirectToRecord,
            );
          },
        ),
      ),
    );
  }

  Future<void> _showCalendarDialog(
    BuildContext context,
    StatViewmodel viewModel,
  ) async {
    final repository = context.read<BloodPressureRepository>();
    final selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (_) => CalendarSDK(
        initialDate: viewModel.focusedDate,
        firstDate: DateTime(repository.getMinYear()),
        lastDate: DateTime.now(),
        type: viewModel.currentCalendarType,
      ),
    );

    if (selectedDate != null) {
      viewModel.onCalendarDateSelected(selectedDate);
    }
  }
}

/// Data class สำหรับ Selector — rebuild เฉพาะเมื่อ data จริงเปลี่ยน
@immutable
class _StatSummaryData {
  final String dateLabel;
  final AnalyzeState analyzeState;
  final AnalyzeResultModel? resultFromAi;
  final int? bloodPressureLevel;
  final List<StatCardData> statsData;
  final List<BloodPressureGraphData> graphData;
  final bool isInternetConnected;
  final bool isLoading;

  const _StatSummaryData({
    required this.dateLabel,
    required this.analyzeState,
    required this.resultFromAi,
    required this.bloodPressureLevel,
    required this.statsData,
    required this.graphData,
    required this.isInternetConnected,
    required this.isLoading,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _StatSummaryData &&
          dateLabel == other.dateLabel &&
          analyzeState == other.analyzeState &&
          resultFromAi == other.resultFromAi &&
          bloodPressureLevel == other.bloodPressureLevel &&
          listEquals(statsData, other.statsData) &&
          listEquals(graphData, other.graphData) &&
          isInternetConnected == other.isInternetConnected &&
          isLoading == other.isLoading;

  @override
  int get hashCode => Object.hash(
    dateLabel,
    analyzeState,
    resultFromAi,
    bloodPressureLevel,
    Object.hashAll(statsData),
    Object.hashAll(graphData),
    isInternetConnected,
    isLoading,
  );
}
