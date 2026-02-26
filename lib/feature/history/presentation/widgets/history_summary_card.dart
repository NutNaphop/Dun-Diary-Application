import 'package:dun_diary_app/feature/history/presentation/history_viewmodel.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:dun_diary_app/shared/widgets/ui/guage/guage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistorySummaryCard extends StatelessWidget {
  const HistorySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistoryViewmodel>();

    final label = AppStrings.bloodPressure.bloodPressure(
      BloodPressureUtils.mapLevelLabel(
        vm.getAverageLevelForDate(vm.selectedDate),
      ),
    );

    if (vm.selectedDateRecords.isEmpty) {
      return const SizedBox.shrink();
    }

    final lastRecordLevel = BloodPressureUtils.calculateBloodPressureLevel(
      vm.selectedDateRecords.first.sys,
      vm.selectedDateRecords.first.dia,
    );

    final avgLevel = vm.getAverageLevelForDate(vm.selectedDate);

    return CustomCard(
      contentPadding: const EdgeInsets.all(10),
      content: Column(
        children: [
          CustomText(
            text: label,
            fontSize: Dimension.fontSizes.h1,
            fontWeight: Dimension.fontWeights.bold,
            color: CustomColor.gray900,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          CustomText(
            text: DateTimeUtils.getHistoryTimeLabel(
              vm.selectedDateRecords.firstOrNull?.createdAt,
            ),
            fontSize: Dimension.fontSizes.md,
            fontWeight: Dimension.fontWeights.medium,
            color: CustomColor.gray500,
            textAlign: TextAlign.center,
          ),
          BloodPressureGauge(level: lastRecordLevel, avgLevel: avgLevel),
        ],
      ),
    );
  }
}
