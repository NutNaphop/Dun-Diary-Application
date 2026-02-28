import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final Widget leadingIcon;
  final String title;
  final String value;
  final String description;

  const StatCard({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.value,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      content: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              leadingIcon,
              SizedBox(width: 10),
              CustomText(
                text: title,
                fontSize: Dimension.fontSizes.md,
                fontWeight: Dimension.fontWeights.regular,
              ),
            ],
          ),
          CustomText(
            text: value,
            fontSize: Dimension.fontSizes.h1,
            fontWeight: Dimension.fontWeights.bold,
          ),
          CustomText(
            text: description,
            fontSize: Dimension.fontSizes.rg,
            fontWeight: Dimension.fontWeights.regular,
            color: CustomColor.gray500,
          ),
        ],
      ),
    );
  }
}

class StatCardData {
  String iconPath;
  String title;
  String value;
  String description;
  Color foreground;
  Color background;

  StatCardData({
    required this.iconPath,
    required this.title,
    required this.value,
    required this.description,
    required this.foreground,
    required this.background,
  });
}
