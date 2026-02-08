import 'package:dun_diary_app/data/analyze_record/repository/analyze_repository.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/feature/stat/presentation/stat_viewModel.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/views/stat_summary_view.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/calendar_sdk.dart';
import 'package:dun_diary_app/shared/widgets/ui/tab_bar/app_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => StatViewmodel(
        context.read<BloodPressureRepository>(),
        context.read<AnalyzeRepository>(),
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
    final viewModel = context.watch<StatViewmodel>();
    final _repository = context.read<BloodPressureRepository>();
    return CustomScaffold(
      appBar: MainAppBar(
        title: AppStrings.stat.stat,
        showBack: false,
        actions: [
          IconButtonSVG(
            path: AppIcons.outline.calendar,
            onPressed: () => _showCalendarDialog(viewModel, _repository),
          ),
          IconButtonSVG(
            path: AppIcons.outline.dotThree,
            onPressed: () => viewModel.seedData(),
          ),
        ],
      ),
      body: AppTabBar(
        onTap: (index) => viewModel.setTabIndex(index), // อัปเดตค่าใน ViewModel
        titles: [
          AppStrings.calendar.week,
          AppStrings.calendar.month,
          AppStrings.calendar.year,
        ],
        tabViews: [
          StatSummaryView(
            dateLabel: viewModel.currentRangeLabel,
            analyzeState: viewModel.analyzeState,
            resultFromAi: viewModel.aiResultContent,
            bloodPressureLevel: viewModel.bloodPressureLevel,
            data: viewModel.statsData,
            graphData: viewModel.graphData,
            onAnalyzePressed: viewModel.triggerAnalyze,
          ), // ข้อมูลสัปดาห์
          StatSummaryView(
            dateLabel: viewModel.currentRangeLabel,
            analyzeState: viewModel.analyzeState,
            resultFromAi: viewModel.aiResultContent,
            bloodPressureLevel: viewModel.bloodPressureLevel,
            data: viewModel.statsData,
            graphData: viewModel.graphData,
            onAnalyzePressed: viewModel.triggerAnalyze,
          ), // ข้อมูลเดือน
          StatSummaryView(
            dateLabel: viewModel.currentRangeLabel,
            analyzeState: viewModel.analyzeState,
            resultFromAi: viewModel.aiResultContent,
            bloodPressureLevel: viewModel.bloodPressureLevel,
            data: viewModel.statsData,
            graphData: viewModel.graphData,
            onAnalyzePressed: viewModel.triggerAnalyze,
          ), // ข้อมูลปี
        ],
      ),
    );
  }

  Future<void> _showCalendarDialog(
    StatViewmodel viewModel,
    BloodPressureRepository repository,
  ) async {
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
