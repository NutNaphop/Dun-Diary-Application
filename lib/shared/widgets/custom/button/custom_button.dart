import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

enum CustomButtonType { outline, fill }

class CustomButton extends StatelessWidget {
  final String text;
  final CustomButtonType type;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onPressed;
  final MainAxisAlignment? mainAxisAlignment;
  final bool expand;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = CustomButtonType.outline,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 25.0,
    this.textStyle,
    this.width,
    this.height,
    this.padding,
    this.leadingIcon,
    this.trailingIcon,
    this.boxShadow,
    this.mainAxisAlignment,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final isFill = type == CustomButtonType.fill;
    final isDisabled = onPressed == null;

    final effectiveBackgroundColor = isDisabled
        ? (isFill ? CustomColor.gray200 : CustomColor.white)
        : (backgroundColor ??
              (isFill ? CustomColor.accentColor : CustomColor.white));

    final effectiveBorderColor = isDisabled
        ? CustomColor.gray300
        : (borderColor ?? (isFill ? Colors.transparent : CustomColor.gray300));

    final defaultTextColor = isDisabled
        ? CustomColor.gray500
        : (isFill ? CustomColor.white : CustomColor.gray900);

    final effectiveTextStyle =
        textStyle ??
        TextStyle(
          color: defaultTextColor,
          fontSize: Dimension.fontSizes.h2,
          fontWeight: Dimension.fontWeights.semiBold,
        );

    final effectiveMainAxisAlignment =
        mainAxisAlignment ??
        (leadingIcon != null && trailingIcon != null
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius!),
        boxShadow: boxShadow,
      ),
      child: Material(
        color: effectiveBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
          side: BorderSide(color: effectiveBorderColor, width: 1.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            width: width,
            height: height,
            padding:
                padding ??
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(
              mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: effectiveMainAxisAlignment,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (leadingIcon != null) ...[
                      leadingIcon!,
                      const SizedBox(width: 8),
                    ],
                    CustomText(
                      text: text,
                      color: effectiveTextStyle.color ?? defaultTextColor,
                      fontSize: effectiveTextStyle.fontSize!,
                      fontWeight: effectiveTextStyle.fontWeight!,
                    ),
                  ],
                ),
                if (trailingIcon != null) ...[
                  if (effectiveMainAxisAlignment !=
                      MainAxisAlignment.spaceBetween)
                    const SizedBox(width: 8),
                  Container(
                    height: 28,
                    width: 28,
                    decoration: const BoxDecoration(
                      color: CustomColor.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: trailingIcon!),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
