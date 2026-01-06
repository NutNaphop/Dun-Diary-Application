import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/widgets/custom/snackbar/custom_snackbar.dart';
import 'package:dun_diary_app/shared/widgets/custom/svg/custom_svg_widget.dart';
import 'package:flutter/material.dart';

class SnackBarService {
  static final SnackBarService instance = SnackBarService._();
  SnackBarService._();

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showSuccess(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      CustomSnackBar(
        message: message,
        backgroundColor: CustomColor.green100,
        borderColor: CustomColor.green200,
        textColor: CustomColor.green300,
        leadingIcon: SVGImage(
          path: AppIcons.duotone.check_circle,
          size: 28,
          color: CustomColor.green300,
        ),
        trailingIcon: SVGImage(
          path: AppIcons.outline.x,
          size: 24,
          color: CustomColor.green300,
        ),
      ),
    );
  }

  void showError(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      CustomSnackBar(
        message: message,
        backgroundColor: CustomColor.red100,
        borderColor: CustomColor.red200,
        textColor: CustomColor.red300,
        leadingIcon: SVGImage(
          path: AppIcons.duotone.danger,
          size: 28,
          color: CustomColor.red300,
        ),
        trailingIcon: SVGImage(
          path: AppIcons.outline.x,
          size: 24,
          color: CustomColor.red300,
        ),
      ),
    );
  }

  void showWarning(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      CustomSnackBar(
        message: message,
        backgroundColor: CustomColor.yellow100,
        borderColor: CustomColor.yellow200,
        textColor: CustomColor.yellow300,
        leadingIcon: SVGImage(
          path: AppIcons.duotone.dangerTriangle,
          size: 28,
          color: CustomColor.yellow300,
        ),
        trailingIcon: SVGImage(
          path: AppIcons.outline.x,
          size: 24,
          color: CustomColor.yellow300,
        ),
      ),
    );
  }

  void showInfo(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      CustomSnackBar(
        message: message,
        backgroundColor: CustomColor.blue100,
        borderColor: CustomColor.blue200,
        textColor: CustomColor.blue300,
        leadingIcon: SVGImage(
          path: AppIcons.duotone.check_circle,
          size: 28,
          color: CustomColor.blue300,
        ),
        trailingIcon: SVGImage(
          path: AppIcons.outline.x,
          size: 24,
          color: CustomColor.blue300,
        ),
      ),
    );
  }

  void clear() {
    scaffoldMessengerKey.currentState?.clearSnackBars();
  }
}
