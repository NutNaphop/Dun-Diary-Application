import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget trailing;
  final bool hasDivider;

  const CardItem({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.hasDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                leading,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  CustomText(text: title, fontSize: Dimension.fontSizes.md, fontWeight: Dimension.fontWeights.semiBold),
                  CustomText(text: subtitle, fontSize: Dimension.fontSizes.rg, fontWeight: Dimension.fontWeights.regular)
                ]),
              ],
            ),
            trailing,
          ],
        ),
        if (hasDivider) Divider(
          color: CustomColor.gray200,
        )
      ],
    );
  }
}
