import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/feature/history/presentation/history_viewmodel.dart';
import 'package:dun_diary_app/feature/history/presentation/widgets/history_csv_export_sheet.dart';
import 'package:dun_diary_app/feature/history/presentation/widgets/history_graph_card.dart';
import 'package:dun_diary_app/feature/history/presentation/widgets/history_pic_export_sheet.dart';
import 'package:dun_diary_app/feature/history/presentation/widgets/history_record_list.dart';
import 'package:dun_diary_app/feature/history/presentation/widgets/history_summary_card.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:flutter/material.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_popup_menu.dart';
import 'package:dun_diary_app/shared/widgets/ui/date_slider/date_slider.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/calendar_sdk.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/models/calendar_types.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) =>
          HistoryViewmodel(repository: context.read<BloodPressureRepository>()),
      child: const HistoryScreen(),
    );
  }

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: MainAppBar(
        title: AppStrings.history.pageTitle,
        showBack: false,
        actions: [
          IconButtonSVG(
            path: AppIcons.outline.calendar,
            onPressed: () => _openCalendar(context),
          ),
          CustomPopupMenuButton(
            menuMinWidth: 205,
            openAbove: false,
            offset: const Offset(0, 30),
            icon: SVGImage(path: AppIcons.outline.dotThree),
            items: [
              PopupMenuItem(
                child: CustomText(
                  text: AppStrings.history.exportImage,
                  fontSize: Dimension.fontSizes.md,
                  fontWeight: Dimension.fontWeights.regular,
                ),
                onTap: () async {
                  await Future.delayed(Duration.zero);
                  if (!context.mounted) return;
                  _showImageExportSheet(context);
                },
              ),
              PopupMenuItem(
                child: CustomText(
                  text: AppStrings.history.exportCsv,
                  fontSize: Dimension.fontSizes.md,
                  fontWeight: Dimension.fontWeights.regular,
                ),
                onTap: () async {
                  await Future.delayed(Duration.zero);
                  if (!context.mounted) return;
                  _showCsvExportSheet(context);
                },
              ),
            ],
          ),
        ],
      ),
      body: Consumer<HistoryViewmodel>(
        builder: (context, vm, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: Column(
                spacing: 15,
                children: [
                  SizedBox(
                    height: 110,
                    child: DateSlider(
                      selectedDate: vm.selectedDate,
                      onDateSelected: vm.selectDate,
                      enableScrollFutureUntil: vm.latestDataDate,
                      dateColorBuilder: (date) {
                        final level = vm.getAverageLevelForDate(date);
                        return level?.color ?? Colors.transparent;
                      },
                      warningDotBuilder: (date) {
                        return vm.hasHighLevelRecord(date);
                      },
                    ),
                  ),

                  if (vm.selectedDateRecords.isNotEmpty)
                    const HistorySummaryCard(),
                  const HistoryGraphCard(),
                  const HistoryRecordList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openCalendar(BuildContext context) async {
    final vm = context.read<HistoryViewmodel>();
    final repository = context.read<BloodPressureRepository>();
    final DateTime? result = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        return CalendarSDK(
          type: CalendarType.week,
          initialDate: vm.selectedDate,
          firstDate: DateTime(repository.getMinYear()),
          lastDate: DateTime.now(),
        );
      },
    );

    if (result != null) {
      vm.selectDate(result);
    }
  }

  void _showCsvExportSheet(BuildContext context) {
    HistoryCSVExportSheet.show(context);
  }

  void _showImageExportSheet(BuildContext context) {
    HistoryPicExportSheet.show(context);
  }
}
