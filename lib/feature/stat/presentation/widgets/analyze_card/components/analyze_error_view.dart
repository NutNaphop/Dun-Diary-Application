import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_image.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class AnalyzeErrorView extends StatelessWidget {
  final bool isInternetConnect;
  final VoidCallback? onPressed;

  const AnalyzeErrorView({
    super.key,
    this.isInternetConnect = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final buttonContentColor = isInternetConnect
        ? CustomColor.accentColor
        : CustomColor.gray400;
    final buttonCallback = isInternetConnect ? onPressed : null;
    final buttonStrokeColor = isInternetConnect
        ? CustomColor.accentColor
        : CustomColor.gray400;

    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 15,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            spacing: 8,
            children: [
              SVGImage(path: AppImage.analyzeError, width: 150, height: 150),
              CustomText(
                text: AppStrings.stat.errorTitle,
                fontSize: Dimension.fontSizes.h1,
                fontWeight: Dimension.fontWeights.bold,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: CustomText(
                  text: AppStrings.stat.errorDesc,
                  fontSize: Dimension.fontSizes.md,
                  fontWeight: Dimension.fontWeights.regular,
                  color: CustomColor.gray600,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 76),
                child: CustomButton(
                  type: CustomButtonType.outline,
                  boxShadow: [DropShadow.drop_card],
                  textStyle: TextStyle(
                    color: buttonContentColor,
                    fontSize: Dimension.fontSizes.md,
                    fontWeight: Dimension.fontWeights.bold,
                  ),
                  leadingIcon: SVGImage(
                    path: AppIcons.outline.arrowClockwise,
                    width: 20,
                    height: 20,
                    color: buttonContentColor,
                  ),
                  mainAxisAlignment: MainAxisAlignment.center,
                  text: AppStrings.stat.tryAgain,
                  borderColor: buttonStrokeColor,
                  onPressed: buttonCallback,
                ),
              ),

              if (!isInternetConnect)
                CustomText(
                  text: AppStrings.stat.connectInternet,
                  fontSize: Dimension.fontSizes.rg,
                  fontWeight: Dimension.fontWeights.regular,
                  color: CustomColor.orange3,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
