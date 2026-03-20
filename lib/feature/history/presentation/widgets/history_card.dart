import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  final BPRecord record;
  final bool isHaveDivider;

  const HistoryCard({
    super.key,
    required this.record,
    this.isHaveDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final level = BloodPressureUtils.calculateBloodPressureLevel(
      record.sys,
      record.dia,
    );
    return Column(
      spacing: 6,
      children: [
        Row(
          children: [
            SizedBox(
              width: 60,
              child: Column(
                children: [
                  CustomText(
                    text: record.sys.toString(),
                    fontSize: Dimension.fontSizes.h1,
                    fontWeight: Dimension.fontWeights.bold,
                    color: CustomColor.gray900,
                    textAlign: TextAlign.center,
                  ),
                  CustomText(
                    text: record.dia.toString(),
                    fontSize: Dimension.fontSizes.h1,
                    fontWeight: Dimension.fontWeights.bold,
                    color: CustomColor.gray900,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Row(
              spacing: 15,
              children: [
                Container(
                  width: 5,
                  height: 80,
                  decoration: BoxDecoration(
                    color: level.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Column(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: level.label,
                      fontSize: Dimension.fontSizes.h2,
                      fontWeight: Dimension.fontWeights.bold,
                      color: CustomColor.gray900,
                    ),
                    CustomText(
                      text: AppStrings.bloodPressure.pulseDescFormat(
                        record.pulse.toString(),
                      ),
                      fontSize: Dimension.fontSizes.md,
                      fontWeight: Dimension.fontWeights.regular,
                      color: CustomColor.gray900,
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: DateTimeUtils.formatToTime(record.createdAt),
                          fontSize: Dimension.fontSizes.rg,
                          fontWeight: Dimension.fontWeights.regular,
                          color: CustomColor.gray500,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const Spacer(),
            IconButtonSVG(
              path: AppIcons.outline.rightArrow,
              width: 22,
              height: 22,
              color: CustomColor.gray400,
            ),
          ],
        ),
        if (isHaveDivider)
          const Divider(height: 0.5, color: CustomColor.gray200),
      ],
    );
  }
}
