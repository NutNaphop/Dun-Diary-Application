import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class NoDataLayout extends StatelessWidget {
  final String heading;
  final VoidCallback? onButtonPress;

  const NoDataLayout({super.key, required this.heading, this.onButtonPress});

  @override
  Widget build(BuildContext context) {
    final headingText = AppStrings.bpGraphSdk.noDataFor(heading);
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        spacing: 50,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            spacing: 5,
            children: [
              CustomText(
                text: headingText,
                fontSize: Dimension.fontSizes.h2,
                fontWeight: Dimension.fontWeights.bold,
              ),
              CustomText(
                text: AppStrings.bpGraphSdk.graphWillShowHere,
                fontSize: Dimension.fontSizes.rg,
                fontWeight: Dimension.fontWeights.medium,
              ),
            ],
          ),

          CustomButton(
            text: AppStrings.bpGraphSdk.addRecordToday,
            type: CustomButtonType.fill,
            backgroundColor: CustomColor.accentColor,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: Dimension.fontSizes.h2,
              fontWeight: Dimension.fontWeights.bold,
            ),
            width: 150,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            onPressed: onButtonPress ?? () {},
          ),
        ],
      ),
    );
  }
}
