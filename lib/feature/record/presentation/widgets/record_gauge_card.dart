import 'package:dun_diary_app/feature/record/presentation/record_viewModel.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/ui/guage/guage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordGaugeCard extends StatelessWidget {
  const RecordGaugeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<RecordViewmodel, int>(
      selector: (_, viewModel) => viewModel.level,
      builder: (context, level, child) => CustomCard(
        title: AppStrings.bloodPressure.bloodPressure(
          BloodPressureUtils.mapLevelLabel(level),
        ),
        titleFontSize: 21,
        titleTextAlign: TextAlign.center,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        content: BloodPressureGauge(level: level),
      ),
    );
  }
}
