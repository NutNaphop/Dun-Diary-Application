import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class BloodPressureCard extends StatelessWidget {
  final int? bloodPressureLevel;
  final String date;
  final Widget leadingIcon;

  const BloodPressureCard({
    super.key,
    this.bloodPressureLevel,
    required this.date,
    required this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final resultLabel = bloodPressureLevel == null
        ? AppStrings.stat.noDataYet
        : AppStrings.stat.bpLevel(
            BloodPressureUtils.mapLevelLabel(bloodPressureLevel),
          );
    return CustomCard(
      contentPadding: EdgeInsets.all(15),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leadingIcon,
          const SizedBox(width: 12), // เพิ่มระยะห่าง
          Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: resultLabel,
                fontSize: Dimension.fontSizes.xl,
                fontWeight: Dimension.fontWeights.bold,
                color: BloodPressureUtils.mapLevelColor(bloodPressureLevel),
              ),
              CustomText(
                text: date,
                fontSize: Dimension.fontSizes.md,
                fontWeight: Dimension.fontWeights.regular,
                color: CustomColor.gray500,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
