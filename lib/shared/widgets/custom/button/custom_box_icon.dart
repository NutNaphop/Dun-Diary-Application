import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/widgets/custom/svg/custom_svg_widget.dart';
import 'package:flutter/material.dart';

class CustomBoxIcon extends StatelessWidget {
  final String iconPath;
  final String? activeIconPath; // เพิ่ม: ไอคอนที่จะแสดงเมื่อถูกกด (Active)
  final bool isActive;
  final Color backgroundColor;
  final Color iconColor;
  final double iconSize;
  final double borderRadius;
  final VoidCallback? onPressed;

  const CustomBoxIcon({
    super.key,
    required this.iconPath,
    this.isActive = false,
    this.activeIconPath,
    this.backgroundColor = CustomColor.accentColor,
    this.iconColor = CustomColor.white,
    this.iconSize = 24,
    this.borderRadius = 15,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: backgroundColor,
      ),
      child: IgnorePointer(
        ignoring: onPressed == null,
        child: IconButtonSVG(
          path: (isActive && activeIconPath != null)
              ? activeIconPath!
              : iconPath,
          width: iconSize,
          height: iconSize,
          color: iconColor,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
