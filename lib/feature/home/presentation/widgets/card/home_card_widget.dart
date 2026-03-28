import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/card_item.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';


class ContentCard extends StatelessWidget {
  final Widget leading;
  final String label;
  final String description;
  final String value;

  const ContentCard({
    super.key,
    required this.leading,
    required this.label,
    required this.description,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return CardItem(
      leading: leading,
      title: label,
      subtitle: description,
      trailing: CustomText(
        text: value,
        fontSize: Dimension.fontSizes.h1,
        fontWeight: Dimension.fontWeights.semiBold,
      ),
      hasDivider: label != AppStrings.bloodPressure.pulseShortLabel,
    );
  }
}
