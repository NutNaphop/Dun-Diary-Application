import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class CustomPopupMenuItem<T> extends PopupMenuItem<T> {
  CustomPopupMenuItem({
    super.key,
    required T value,
    required String title,
    TextStyle? textStyle,
    Widget? icon,
  }) : super(
          value: value,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon,
                const SizedBox(width: 10),
              ],
              CustomText(text: title, fontSize: Dimension.fontSizes.md, fontWeight: Dimension.fontWeights.regular,)
            ],
          ),
        );
}

class CustomPopupMenuButton<T> extends StatelessWidget {
  final List<PopupMenuEntry<T>> items;
  final void Function(T)? onSelected;
  final VoidCallback? onOpened;
  final VoidCallback? onCanceled;
  final Widget icon;
  final Offset offset;
  final Color? backgroundColor;
  final ShapeBorder? shape;

  const CustomPopupMenuButton({
    super.key,
    required this.items,
    required this.icon,
    this.onSelected,
    this.onOpened,
    this.onCanceled,
    this.offset = Offset.zero,
    this.backgroundColor,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      offset: offset,
      icon: icon,
      onSelected: onSelected,
      onOpened: onOpened,
      onCanceled: onCanceled,
      itemBuilder: (context) => items,
      color: backgroundColor ?? Colors.white,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
      elevation: 3,
    );
  }
}