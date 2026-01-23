import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:flutter/material.dart';

class CalendarFooter extends StatelessWidget {
  final bool isSubPage;
  final VoidCallback onSelect;
  final VoidCallback onGoToPresent;
  final String goToPresentLabel;

  const CalendarFooter({
    super.key,
    this.isSubPage = false,
    required this.onSelect,
    required this.onGoToPresent,
    required this.goToPresentLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
      children: [
        CustomButton(
          text: AppStrings.calendar.select,
          type: CustomButtonType.fill,
          backgroundColor: CustomColor.accentColor,
          boxShadow: [DropShadow.drop_thumb],
          onPressed: onSelect,
        ),
        if (!isSubPage) ...[
          CustomButton(
            text: goToPresentLabel,
            type: CustomButtonType.outline,
            boxShadow: [DropShadow.drop_thumb],
            onPressed: onGoToPresent,
          ),
        ],
      ],
    );
  }
}
