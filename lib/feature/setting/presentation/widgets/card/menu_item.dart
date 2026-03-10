import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final Widget leadingIcon;
  final Widget actionIcon;
  final String title;
  final VoidCallback onTap;
  final bool isHaveDivider;
  final BorderRadius? borderRadius;

  const MenuItem({
    super.key,
    required this.leadingIcon,
    required this.actionIcon,
    required this.title,
    required this.onTap,
    this.isHaveDivider = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  leadingIcon,
                  SizedBox(width: 15),
                  CustomText(
                    text: title,
                    fontSize: Dimension.fontSizes.h2,
                    fontWeight: Dimension.fontWeights.semiBold,
                  ),
                  Spacer(),
                  actionIcon,
                ],
              ),
            ),
            if (isHaveDivider)
              Divider(
                color: CustomColor.gray200,
                thickness: 1,
                height: 1, // Ensure divider doesn't add extra height
              ),
          ],
        ),
      ),
    );
  }
}
