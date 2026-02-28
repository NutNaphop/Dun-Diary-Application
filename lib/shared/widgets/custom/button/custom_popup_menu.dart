import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class CustomPopupMenuButton<T> extends StatelessWidget {
  final List<PopupMenuEntry<T>> items;
  final void Function(T)? onSelected;
  final VoidCallback? onOpened;
  final VoidCallback? onCanceled;
  final Widget icon;
  final Offset offset;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final bool openAbove;
  final double menuMinWidth;

  // สมมติว่านี่คือ Shadow ของคุณ (หรือรับมาจากข้างนอกก็ได้)
  final List<BoxShadow>? customBoxShadows;

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
    this.openAbove = false,
    this.menuMinWidth = 160,
    this.customBoxShadows, // รับค่า Shadow
  });

  @override
  Widget build(BuildContext context) {
    Offset effectiveOffset = offset;

    if (openAbove) {
      double menuHeight = 16.0;
      const double dividerHeight = 10.0;
      const double estimatedItemHeight = 35;

      for (int i = 0; i < items.length; i++) {
        if (items[i] is CustomPopupMenuItem) {
          menuHeight += estimatedItemHeight;
        } else {
          menuHeight += items[i].height;
        }

        if (i < items.length - 1) {
          menuHeight += dividerHeight;
        }
      }
      effectiveOffset = Offset(offset.dx, -menuHeight + offset.dy);
    }

    return PopupMenuButton<T>(
      constraints: BoxConstraints(minWidth: menuMinWidth),
      offset: effectiveOffset,
      popUpAnimationStyle: AnimationStyle.noAnimation,
      icon: icon,
      onSelected: onSelected,
      onOpened: onOpened,
      onCanceled: onCanceled,
      elevation: 0,
      color: Colors.transparent,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      itemBuilder: (context) {
        final List<Widget> innerChildren = [];
        for (int i = 0; i < items.length; i++) {
          innerChildren.add(items[i]);
          if (i < items.length - 1) {
            innerChildren.add(DashedPopupMenuDivider(defaultHeight: 1));
          }
        }

        return [
          PopupMenuItem<T>(
            enabled: false,
            padding: EdgeInsets.zero,
            height: 10,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: CustomColor.gray300),
                boxShadow: [DropShadow.drop_popup],
              ),
              clipBehavior: Clip.hardEdge, // ตัดขอบมน
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: innerChildren,
              ),
            ),
          ),
        ];
      },
    );
  }
}

class DashedPopupMenuDivider extends PopupMenuEntry<Never> {
  const DashedPopupMenuDivider({super.key, this.defaultHeight = 10.0});

  final double defaultHeight;

  @override
  double get height => defaultHeight;

  @override
  bool represents(void value) => false;

  @override
  State<DashedPopupMenuDivider> createState() => _DashedPopupMenuDividerState();
}

class _DashedPopupMenuDividerState extends State<DashedPopupMenuDivider> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Center(
        child: CustomPaint(
          size: const Size(double.infinity, 1),
          painter: _DashedLinePainter(),
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 4.0;
    const dashSpace = 2.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CustomPopupMenuItem<T> extends PopupMenuItem<T> {
  CustomPopupMenuItem({
    super.key,
    required T value,
    required String title,
    TextStyle? textStyle,
    Widget? icon,
  }) : super(
         value: value,
         padding: EdgeInsets.zero,
         height: 0,
         child: Padding(
           padding: EdgeInsetsGeometry.symmetric(vertical: 11, horizontal: 15),
           child: Row(
             mainAxisSize: MainAxisSize.max,
             children: [
               if (icon != null) ...[icon, const SizedBox(width: 10)],
               CustomText(
                 text: title,
                 fontSize: Dimension.fontSizes.md,
                 fontWeight: Dimension.fontWeights.regular,
               ),
             ],
           ),
         ),
       );
}
