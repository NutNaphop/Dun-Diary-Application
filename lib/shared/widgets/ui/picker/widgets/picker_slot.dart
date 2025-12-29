import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class PickerSlot extends StatelessWidget {
  final String label;
  final Widget trailingIcon;
  final String displayText;
  final VoidCallback? onTap;

  const PickerSlot({
    super.key,
    required this.label,
    required this.trailingIcon,
    required this.displayText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: CustomColor.gray900,
                fontSize: Dimension.fontSizes.sm,
                fontWeight: Dimension.fontWeights.medium,
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              fillColor: CustomColor.white,
              filled: true,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: displayText,
                  fontSize: Dimension.fontSizes.md,
                  fontWeight: Dimension.fontWeights.regular,
                ),
                trailingIcon,
              ],
            ),
          ),
        ),
    );
  }
}
