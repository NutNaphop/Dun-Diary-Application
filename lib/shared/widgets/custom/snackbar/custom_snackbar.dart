import 'package:dun_diary_app/core/services/snackbar_service.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    super.key,
    required String message,
    Color backgroundColor = Colors.black,
    Color borderColor = CustomColor.transparent,
    Color textColor = Colors.white,
    Widget? leadingIcon,
    Widget? trailingIcon,
  }) : super(
         content: _SnackBarContent(
           message: message,
           backgroundColor: backgroundColor,
           borderColor: borderColor,
           textColor: textColor,
           leadingIcon: leadingIcon,
           trailingIcon: trailingIcon,
         ),
         backgroundColor: Colors.transparent,
         elevation: 0,
         behavior: SnackBarBehavior.floating,
         padding: EdgeInsets.zero,
       );
}

class _SnackBarContent extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const _SnackBarContent({
    Key? key,
    required this.message,
    required this.backgroundColor,
    required this.borderColor,
    this.leadingIcon,
    this.trailingIcon,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [DropShadow.drop_thumb],
      ),
      child: Row(
        children: [
          if (leadingIcon != null) ...[leadingIcon!, SizedBox(width: 15)],
          Expanded(
            child: CustomText(
              text: message,
              color: textColor,
              fontSize: Dimension.fontSizes.md,
              fontWeight: Dimension.fontWeights.semiBold,
            ),
          ),
          if (trailingIcon != null) ...[
            GestureDetector(
              onTap: () {
                SnackBarService.instance.clear();
              },
              child: trailingIcon!,
            )
          ],
        ],
      ),
    );
  }
}
