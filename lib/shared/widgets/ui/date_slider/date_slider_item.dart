// date_slider_item.dart

import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class DateSliderItem extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool showWarningDot;
  final Color backgroundColor;
  final VoidCallback onTap;

  const DateSliderItem({
    super.key,
    required this.date,
    required this.isSelected,
    this.showWarningDot = false,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSunday = date.weekday == DateTime.sunday;
    final isFirstOfMonth = date.day == 1;
    final text = (isSelected || isFirstOfMonth)
        ? "${date.day}/${date.month}"
        : "${date.day}";

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. ชื่อวัน: อยู่นอกส่วนสีขาวเสมอ ตาม Design
          Flexible(
            child: CustomText(
              text: DateTimeUtils.getDayName(date.weekday),
              color: isSunday ? CustomColor.red4 : CustomColor.gray900,
              fontSize: Dimension.fontSizes.h2,
              fontWeight: Dimension.fontWeights.semiBold,
              overflow: TextOverflow.ellipsis, // กันล้น
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 12,
              left: 6,
              right: 6,
            ),
            decoration: BoxDecoration(
              color: isSelected ? CustomColor.white : Colors.transparent,
              border: isSelected
                  ? Border.all(color: CustomColor.gray200, width: 1)
                  : null,
              borderRadius: BorderRadius.circular(100),
              boxShadow: isSelected ? [DropShadow.drop_card] : null,
            ),
            child: Column(
              children: [
                _buildBubble(text),
                const SizedBox(height: 7),
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: showWarningDot
                        ? CustomColor.red6
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(String text) {
    const double bubbleSize = 40.0;

    return Container(
      width: bubbleSize,
      height: bubbleSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor, // สีตามระดับความดัน
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: CustomText(
              text: text,
              color: backgroundColor.computeLuminance() > 0.2
                  ? CustomColor.white
                  : CustomColor.gray900,
              fontSize: Dimension.fontSizes.md,
              fontWeight: Dimension.fontWeights.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}
