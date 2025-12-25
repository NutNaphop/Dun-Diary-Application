import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/text/text_widget.dart';
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
  final VoidCallback onPressed;

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
  });

  @override
  Widget build(BuildContext context) {
    final isFill = type == CustomButtonType.fill;

    final effectiveBackgroundColor =
        backgroundColor ??
        (isFill ? CustomColor.primaryColor : CustomColor.white);

    final effectiveBorderColor =
        borderColor ?? (isFill ? Colors.transparent : CustomColor.primaryColor);

    final defaultTextColor = isFill ? CustomColor.white : CustomColor.gray900;

    final effectiveTextStyle =
        textStyle ??
        TextStyle(
          color: defaultTextColor,
          fontSize: Dimension.fontSizeHeading2,
          fontWeight: Dimension.fontWeightBold,
        );

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
            child: leadingIcon == null && trailingIcon == null
                ? Center(
                    child: CustomText(
                      text: text,
                      color: effectiveTextStyle.color ?? defaultTextColor,
                      fontSize: effectiveTextStyle.fontSize!,
                      fontWeight: effectiveTextStyle.fontWeight!,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                      if (trailingIcon != null)
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
                  ),
          ),
        ),
      ),
    );
  }
}
