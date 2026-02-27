import 'package:dun_diary_app/shared/constant/app_image.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/dialog/custom_dialog.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConfirmRecoveryDialog extends StatelessWidget {
  const ConfirmRecoveryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      content: SvgPicture.asset(AppImages.warning, height: 120),
      title: AppStrings.setting.confirmRecoveryTitle,
      primaryButtonText: AppStrings.setting.confirmRecoveryBtn,
      secondaryButtonText: AppStrings.common.cancel,
      onPrimaryPressed: () {
        Navigator.of(context).pop(true);
      },
      onSecondaryPressed: () {
        Navigator.of(context).pop(false);
      },
      body: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontFamily: Dimension.fontName,
                fontSize: Dimension.fontSizes.h2,
                color: CustomColor.gray600,
              ),
              children: [
                TextSpan(
                  text: AppStrings.setting.thisDataWill,
                  style: TextStyle(fontWeight: Dimension.fontWeights.regular),
                ),
                TextSpan(
                  text: AppStrings.setting.deleted,
                  style: TextStyle(
                    color: CustomColor.red6,
                    fontWeight: Dimension.fontWeights.bold,
                  ),
                ),
                TextSpan(text: AppStrings.setting.andReplacedWith),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CustomText(
            text: AppStrings.setting.duringRecovery,
            color: CustomColor.gray500,
            fontSize: Dimension.fontSizes.md,
            fontWeight: Dimension.fontWeights.regular,
          ),
          const SizedBox(height: 20),
          _BulletPoint(text: AppStrings.setting.connectInternet),
          _BulletPoint(text: AppStrings.setting.doNotCloseOrExit),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6.0, right: 8.0, left: 16.0),
          child: Icon(Icons.circle, size: 6, color: CustomColor.gray500),
        ),
        Expanded(
          child: CustomText(
            text: text,
            color: CustomColor.gray600,
            fontSize: Dimension.fontSizes.h2,
          ),
        ),
      ],
    );
  }
}
