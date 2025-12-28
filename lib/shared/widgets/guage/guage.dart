import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/guage/guage_indicator.dart';
import 'package:dun_diary_app/shared/widgets/guage/utils/guage_utils.dart';
import 'package:dun_diary_app/shared/widgets/svg/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';

class BloodPressureGauge extends StatelessWidget {
  final int level;
  final int? avgLevel;

  const BloodPressureGauge({super.key, required this.level, this.avgLevel});

  @override
  Widget build(BuildContext context) {
    // ความสูงของแถบเกจ
    const double gaugeHeight = 30.0;
    const double borderRadius = gaugeHeight / 2;
    double alignmentAVGValue = avgLevel != null
        ? GuageUtils.getAlignmentForAVGLevel(avgLevel!)
        : 0.0;
    double alignmentValue = GuageUtils.getAlignmentForLevel(level);

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'ต่ำ',
                fontSize: Dimension.fontSizeSmall,
                fontWeight: Dimension.fontWeightRegular,
              ),
              CustomText(
                text: 'สูง',
                fontSize: Dimension.fontSizeSmall,
                fontWeight: Dimension.fontWeightRegular,
              ),
            ],
          ),
        ),
        // ส่วนของแถบสีและดาว
        SizedBox(
          height: gaugeHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // --- Layer 1: แถบพื้นหลังสีๆ ---
              ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: SizedBox(
                  height: gaugeHeight,
                  child: Row(
                    children: [
                      _buildColorSegment(color: CustomColor.dangerColor),
                      _buildColorSegment(color: CustomColor.successColor),
                      _buildColorSegment(color: CustomColor.warningColor),
                      _buildColorSegment(color: CustomColor.quiteDangerColor),
                      _buildColorSegment(color: CustomColor.dangerColor),
                    ],
                  ),
                ),
              ),

              // AVGLine
              if (avgLevel != null)
                AnimatedAlign(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment(alignmentAVGValue, 0),
                  child: CustomPaint(
                    painter: DashedLineVerticalPainter(),
                    size: Size(1, gaugeHeight),
                  ),
                ),

              // IconStar
              AnimatedAlign(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic, // ให้ความรู้สึกนุ่มนวลเวลาขยับ
                alignment: Alignment(alignmentValue, 0),
                child: SVGImage(
                  path: AppIcons.starCircle,
                  size: 24,
                  color: CustomColor.white,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          child: Stack(
            children: [
              // Label
              if (avgLevel != null)
                AnimatedAlign(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment(alignmentAVGValue, 0),
                  child: Container(
                    width: 0,
                    height: 10,
                    child: const OverflowBox(
                      minWidth: 0,
                      maxWidth: double.infinity,
                      minHeight: 0,
                      maxHeight: double.infinity,
                      child: CustomText(
                        text: 'ค่าเฉลี่ย',
                        fontSize: Dimension.fontSizeSmall,
                        fontWeight: Dimension.fontWeightRegular,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper function สำหรับสร้างแถบสีแต่ละช่วง
  Widget _buildColorSegment({required Color color}) {
    return Expanded(
      child: Container(decoration: BoxDecoration(color: color)),
    );
  }
}
