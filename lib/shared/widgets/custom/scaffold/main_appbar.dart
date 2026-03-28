import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack; // (เพิ่ม) บังคับโชว์/ซ่อน ปุ่ม Back
  final String? backIconPath;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final bool centerTitle;

  const MainAppBar({
    super.key,
    this.title,
    this.showBack = true, // Default คือให้โชว์ (สำหรับหน้าย่อยส่วนใหญ่)
    this.backIconPath,
    this.actions,
    this.onBackPressed,
    this.backgroundColor,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBack,
      // ถ้ามีการส่ง onBackPressed มา จะ Override ปุ่ม Back เดิม
      leading: showBack && onBackPressed != null
          ? IconButtonSVG(
              path: backIconPath ?? AppIcons.outline.leftArrow,
              width: 22,
              height: 22,
              color: CustomColor.gray900,
              onPressed: onBackPressed,
            )
          : null,
      titleSpacing: showBack ? 0 : NavigationToolbar.kMiddleSpacing,
      title: CustomText(
        text: title ?? "",
        fontSize: Dimension.fontSizes.h2,
        fontWeight: Dimension.fontWeights.semiBold,
      ),
      centerTitle: centerTitle,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      actions: actions,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: const IconThemeData(
        color: Colors.black,
      ), // ทำให้ปุ่ม Back อัตโนมัติเป็นสีดำ
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
