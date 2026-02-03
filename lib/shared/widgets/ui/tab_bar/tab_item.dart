import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final String title;

  const TabItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: CustomText(
        text: title,
        fontSize: Dimension.fontSizes.md,
        fontWeight: Dimension.fontWeights.medium,
      ),
    );
  }
}
