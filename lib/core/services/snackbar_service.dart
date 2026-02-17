import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/snackbar/custom_snackbar.dart';
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
        backgroundColor: CustomColor.green1,
        borderColor: CustomColor.green2,
        textColor: CustomColor.green3,
        leadingIcon: SVGImage(
          path: AppIcons.duotone.checkCircle,
          width: 28,
          height: 28,
          color: CustomColor.green3,
        ),
        trailingIcon: SVGImage(
          path: AppIcons.outline.x,
          width: 24,
          height: 24,
          color: CustomColor.green3,
        ),
      ),
    );
  }

  void showError(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      CustomSnackBar(
        message: message,
        backgroundColor: CustomColor.red1,
        borderColor: CustomColor.red2,
        textColor: CustomColor.red3,
        leadingIcon: SVGImage(
          path: AppIcons.duotone.danger,
          width: 28,
          height: 28,
          color: CustomColor.red3,
        ),
        trailingIcon: SVGImage(
          path: AppIcons.outline.x,
          width: 24,
          height: 24,
          color: CustomColor.red3,
        ),
      ),
    );
  }

  void showWarning(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      CustomSnackBar(
        message: message,
        backgroundColor: CustomColor.yellow1,
        borderColor: CustomColor.yellow2,
        textColor: CustomColor.yellow3,
        leadingIcon: SVGImage(
          path: AppIcons.duotone.dangerTriangle,
          width: 28,
          height: 28,
          color: CustomColor.yellow3,
        ),
        trailingIcon: SVGImage(
          path: AppIcons.outline.x,
          width: 24,
          height: 24,
          color: CustomColor.yellow3,
        ),
      ),
    );
  }

  void showInfo(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      CustomSnackBar(
        message: message,
        backgroundColor: CustomColor.blue1,
        borderColor: CustomColor.blue2,
        textColor: CustomColor.blue3,
        leadingIcon: SVGImage(
          path: AppIcons.duotone.checkCircle,
          width: 28,
          height: 28,
          color: CustomColor.blue3,
        ),
        trailingIcon: SVGImage(
          path: AppIcons.outline.x,
          width: 24,
          height: 24,
          color: CustomColor.blue3,
        ),
      ),
    );
  }

  void clear() {
    scaffoldMessengerKey.currentState?.clearSnackBars();
  }
}
