import 'package:dun_diary_app/feature/history/presentation/history_viewmodel.dart';
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
    // Access ViewModel using context.watch or context.select if needed updates
    // Here we assume it's rebuilding within a Consumer or we use existing context.watch/read
    // But better to use Consumer or passed data if we want it isolated.
    // However, the original code used Consumer<HistoryViewmodel> at the top level.
    // So we can just use context.read/watch if we are sure it's available.
    // To be safe and cleaner, let's use Consumer inside or just expect Provider.

    final vm = context.watch<HistoryViewmodel>();

    final label = BloodPressureUtils.mapLevelLabel(
      vm.getAverageLevelForDate(vm.selectedDate),
    );

    // Guard against empty records if needed, though previously it seemed safe or handled by logic?
    // In original code: vm.selectedDateRecords.last.sys
    // If records are empty, .last will crash.
    // Let's check how safe it was.
    // It seems vm.selectedDateRecords usage implies it might not be empty or logic handles it.
    // But good practice to handle it.
    // Looking at original code:
    /*
      final lastRecordLevel =
        BloodPressureUtils.calculateBloodPressureLevel(
          vm.selectedDateRecords.last.sys,
          vm.selectedDateRecords.last.dia,
        );
    */
    // If selectedDateRecords is empty, this throws.
    // Assuming ViewModel guarantees data or we should handle it.
    // For now I will copy logic but add a check if list is empty to avoid crash if not guaranteed.

    if (vm.selectedDateRecords.isEmpty) {
      return const SizedBox.shrink(); // Or some empty state
    }

    final lastRecordLevel = BloodPressureUtils.calculateBloodPressureLevel(
      vm.selectedDateRecords.last.sys,
      vm.selectedDateRecords.last.dia,
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
