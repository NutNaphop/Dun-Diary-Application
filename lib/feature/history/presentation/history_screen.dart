import 'package:dun_diary_app/feature/history/presentation/history_viewmodel.dart';
import 'package:dun_diary_app/feature/history/presentation/widgets/history_card.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:dun_diary_app/shared/widgets/ui/date_slider/date_slider.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/bp_graph_sdk.dart';
import 'package:dun_diary_app/shared/widgets/ui/guage/guage.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/calendar_sdk.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/models/calendar_types.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => HistoryViewmodel(),
      child: const HistoryScreen(),
    );
  }

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: MainAppBar(
        title: "รายการบันทึก",
        showBack: false,
        actions: [
          IconButtonSVG(
            path: AppIcons.outline.calendar,
            onPressed: () => _openCalendar(context),
          ),
          IconButtonSVG(path: AppIcons.outline.dotThree, onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Column(
            spacing: 15,
            children: [
              Consumer<HistoryViewmodel>(
                builder: (context, vm, child) {
                  return SizedBox(
                    height: 110,
                    child: DateSlider(
                      selectedDate: vm.selectedDate,
                      onDateSelected: vm.selectDate,
                      enableScrollFutureUntil: vm.latestDataDate,
                      dateColorBuilder: (date) {
                        final level = vm.getAverageLevelForDate(date);
                        return BloodPressureUtils.mapLevelColor(level);
                      },
                    ),
                  );
                },
              ),
              CustomCard(
                contentPadding: EdgeInsets.all(10),
                content: Column(
                  children: [
                    CustomText(
                      text: "ปกติ",
                      fontSize: Dimension.fontSizes.h1,
                      fontWeight: Dimension.fontWeights.bold,
                      color: CustomColor.gray900,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    CustomText(
                      text: "ล่าสุด 11:58",
                      fontSize: Dimension.fontSizes.md,
                      fontWeight: Dimension.fontWeights.medium,
                      color: CustomColor.gray500,
                      textAlign: TextAlign.center,
                    ),
                    BloodPressureGauge(level: 0),
                  ],
                ),
              ),

              CustomCard(
                contentPadding: EdgeInsets.all(10),
                content: SizedBox(
                  height: 343,
                  child: BpGraphSdk(data: List.empty()),
                ),
              ),

              CustomCard(
                title: "รายการบันทึกความดัน",
                contentPadding: const EdgeInsets.all(10),
                content: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: RawScrollbar(
                    thumbColor: CustomColor.gray300,
                    radius: const Radius.circular(90),
                    thickness: 4,
                    thumbVisibility: true,
                    controller: _scrollController,
                    child: Consumer<HistoryViewmodel>(
                      builder: (context, viewModel, child) {
                        return ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: viewModel.selectedDateRecords.length,
                          itemBuilder: (context, index) {
                            final record = viewModel.selectedDateRecords[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: HistoryCard(
                                record: record,
                                isHaveDivider:
                                    index !=
                                    viewModel.selectedDateRecords.length - 1,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCalendar(BuildContext context) async {
    final vm = context.read<HistoryViewmodel>();
    final DateTime? result = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        return CalendarSDK(
          type: CalendarType.week,
          initialDate: vm.selectedDate,
        );
      },
    );

    if (result != null) {
      vm.selectDate(result);
    }
  }
}
