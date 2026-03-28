import 'package:dun_diary_app/data/analyze_record/model/analyze_result_model.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/stat_card/components/stat_icon.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/citation_source.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class AnalyzeSuccessView extends StatelessWidget {
  final AnalyzeResultModel? result;
  final bool isInternetConnect;
  final VoidCallback? onPressed;

  const AnalyzeSuccessView({
    super.key,
    required this.result,
    this.isInternetConnect = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Row(
          spacing: 10,
          children: [
            StatIcon(
              width: 31,
              height: 31,
              backgroundColor: CustomColor.blue6,
              icon: SVGImage(
                path: AppIcons.fill.sparkle,
                color: CustomColor.blue7,
                width: 21,
                height: 21,
              ),
            ),
            CustomText(
              text: AppStrings.stat.aiResult,
              fontSize: Dimension.fontSizes.h2,
              fontWeight: Dimension.fontWeights.semiBold,
            ),
          ],
        ),
        CustomText(
          text: result?.summary ?? "",
          fontSize: Dimension.fontSizes.md,
          fontWeight: Dimension.fontWeights.regular,
        ),

        SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(15),
              border: BoxBorder.all(width: 1, color: CustomColor.blue1),
              color: CustomColor.blue8,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: AppStrings.stat.suggestions,
                  fontSize: Dimension.fontSizes.h2,
                  fontWeight: Dimension.fontWeights.semiBold,
                ),
                SizedBox(height: 5),
                // need to render a data
                ...(result?.suggestions ?? []).map(
                  (suggest) => Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("• "), // Bullet
                        Expanded(
                          child: CustomText(
                            text: suggest,
                            fontSize: Dimension.fontSizes.md,
                            fontWeight: Dimension.fontWeights.regular,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          spacing: 10,
          children: [
            SizedBox(height: 5),
            CustomButton(
              text: AppStrings.stat.reAnalyze,
              expand: false,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              leadingIcon: SVGImage(
                path: AppIcons.outline.arrowClockwise,
                width: 20,
                height: 20,
                color: CustomColor.accentColor,
              ),
              type: CustomButtonType.outline,
              textStyle: TextStyle(
                color: CustomColor.accentColor,
                fontSize: Dimension.fontSizes.md,
                fontWeight: Dimension.fontWeights.bold,
              ),
              borderColor: CustomColor.accentColor,
              onPressed: onPressed,
            ),
            SizedBox(height: 5),
            CitationSource(
              sourceName:
                  result?.reference ?? AppStrings.citation.ahaSourceName,
              url: AppStrings.citation.ahaUrl,
              color: CustomColor.gray600,
            ),
          ],
        ),
      ],
    );
  }
}
