import 'package:another_flushbar/flushbar.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

enum FlushbarType { success, error, warning, info }

class CustomFlushbar {
  // สร้าง Static Method ที่คืนค่าเป็น Flushbar Object
  static Flushbar create(
    BuildContext context, {
    required String message,
    required FlushbarType type,
  }) {
    // กำหนด Theme สีและไอคอนตาม Type
    Color bgColor;
    Color borderColor;
    Color textColor;
    String iconPath;

    switch (type) {
      case FlushbarType.success:
        bgColor = CustomColor.green100;
        borderColor = CustomColor.green200;
        textColor = CustomColor.green300;
        iconPath = AppIcons.duotone.check_circle;
        break;
      case FlushbarType.error:
        bgColor = CustomColor.red100;
        borderColor = CustomColor.red200;
        textColor = CustomColor.red300;
        iconPath = AppIcons.duotone.dangerTriangle;
        break;
      case FlushbarType.warning:
        bgColor = CustomColor.yellow100;
        borderColor = CustomColor.yellow200;
        textColor = CustomColor.yellow300;
        iconPath = AppIcons.duotone.dangerTriangle;
        break;
      case FlushbarType.info:
        bgColor = CustomColor.blue100;
        borderColor = CustomColor.blue200;
        textColor = CustomColor.blue300;
        iconPath = AppIcons.duotone.check_circle;
        break;
    }

    // ส่งกลับ Flushbar ที่แต่งหน้าตาเสร็จแล้ว
    return Flushbar(
      // --- Content ---
      messageText: CustomText(
        text: message,
        color: textColor,
        fontSize: Dimension.fontSizes.md,
        fontWeight: Dimension.fontWeights.semiBold,
      ),

      // ไอคอน
      icon: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: SVGImage(
          path: iconPath,
          height: 28,
          width: 28,
          color: textColor,
        ),
      ),

      // --- Design ---
      backgroundColor: bgColor,
      borderColor: borderColor,
      borderWidth: 1.5,
      borderRadius: BorderRadius.circular(20),

      // --- Position ---
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),

      shouldIconPulse: false,
      animationDuration: const Duration(milliseconds: 700),
      forwardAnimationCurve: Curves.easeOut,
      reverseAnimationCurve: Curves.easeIn,

      // --- Interaction ---
      boxShadows: [DropShadow.drop_thumb],
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,

      // ปุ่มปิด
      mainButton: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: IconButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).maybePop();
          },
          icon: SVGImage(
            path: AppIcons.outline.x,
            width: 24,
            height: 24,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
