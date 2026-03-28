import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? content;
  final String? primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final bool isDismissible;
  final Widget? body;
  final Color? confirmButtonColor;

  const CustomDialog({
    super.key,
    required this.title,
    this.description,
    this.content,
    this.primaryButtonText,
    this.onPrimaryPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.isDismissible = true,
    this.body,
    this.confirmButtonColor,
  });

  static Future<T?> show<T>(BuildContext context, {required Widget child}) {
    return showDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (context) => child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white, // ปรับสีได้ตาม Theme
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Content / Icon / Image
            if (content != null) ...[
              Center(child: content!),
              const SizedBox(height: 30),
            ],

            // 2. Title
            CustomText(
              text: title,
              fontSize: Dimension.fontSizes.h1,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),

            // 3. Description
            if (description != null) ...[
              const SizedBox(height: 8),
              CustomText(
                text: description!,
                fontSize: Dimension.fontSizes.h2,
                color: CustomColor.gray900,
                textAlign: TextAlign.center,
              ),
            ],

            // 4. Custom Body
            if (body != null) ...[const SizedBox(height: 16), body!],

            const SizedBox(height: 24),

            // 4. Actions
            Row(
              children: [
                // Secondary Button (Cancel / No)
                if (secondaryButtonText != null)
                  Expanded(
                    child: CustomButton(
                      text: secondaryButtonText!,
                      type: CustomButtonType.outline,
                      onPressed: () {
                        if (onSecondaryPressed != null) {
                          onSecondaryPressed!();
                        } else {
                          Navigator.of(context).pop(false);
                        }
                      },
                    ),
                  ),

                if (secondaryButtonText != null && primaryButtonText != null)
                  const SizedBox(width: 12),

                // Primary Button (Confirm / Yes / OK)
                if (primaryButtonText != null)
                  Expanded(
                    child: CustomButton(
                      text: primaryButtonText!,
                      type: CustomButtonType.fill,
                      backgroundColor: confirmButtonColor,
                      onPressed: () {
                        if (onPrimaryPressed != null) {
                          onPrimaryPressed!();
                        } else {
                          Navigator.of(context).pop(true);
                        }
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
