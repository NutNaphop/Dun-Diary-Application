import 'package:dun_diary_app/feature/stat/presentation/stat_viewModel.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/views/stat_summary_view.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:dun_diary_app/shared/widgets/ui/tab_bar/app_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => StatViewmodel(),
      child: const StatScreen(),
    );
  }

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context
        .watch<
          StatViewmodel
        >(); // ใช้ watch เพื่อให้ UI rebuild เมื่อ index เปลี่ยน

    return CustomScaffold(
      appBar: MainAppBar(title: AppStrings.stat.stat, showBack: false),
      body: AppTabBar(
        onTap: (index) => viewModel.setTabIndex(index), // อัปเดตค่าใน ViewModel
        titles: [
          AppStrings.calendar.week,
          AppStrings.calendar.month,
          AppStrings.calendar.year,
        ],
        tabViews: [
          StatSummaryView(data: const []), // ข้อมูลสัปดาห์
          StatSummaryView(data: const []), // ข้อมูลเดือน
          StatSummaryView(data: const []), // ข้อมูลปี
        ],
      ),
    );
  }
}
