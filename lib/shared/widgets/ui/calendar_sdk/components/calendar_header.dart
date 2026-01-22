import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';
import '../models/calendar_types.dart';
import '../utils/calendar_utils.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime currentDate;
  final CalendarHeaderStyle style;
  final bool isSubPage;
  final VoidCallback? onMonthTap;
  final VoidCallback? onYearTap;

  const CalendarHeader({
    super.key,
    required this.currentDate,
    required this.style,
    this.isSubPage = false,
    this.onMonthTap,
    this.onYearTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget centerContent;

    // เตรียมข้อมูล
    final monthName = CalendarUtils.thaiMonths[currentDate.month - 1];
    final yearBuddhist = CalendarUtils.toBuddhistYear(currentDate.year);

    if (style == CalendarHeaderStyle.year) {
      centerContent = Center(
        child: _buildTitleHeader(AppStrings.calendar.selectYear),
      );
    } else if (style == CalendarHeaderStyle.month && isSubPage) {
      centerContent = _buildTitleHeader(AppStrings.calendar.selectMonth);
    } else {
      centerContent = Row(
        mainAxisSize: MainAxisSize.min, // จัดกึ่งกลาง
        children: [
          // --- Case: Day or week View ---
          if (style == CalendarHeaderStyle.week ||
              style == CalendarHeaderStyle.day) ...[
            _buildDropdownButton(text: monthName, onTap: onMonthTap),
            const SizedBox(width: 12),
            _buildDropdownButton(text: '$yearBuddhist', onTap: onYearTap),
          ],

          // --- Case: Month View (Main Page) ---
          if (style == CalendarHeaderStyle.month) ...[
            _buildDropdownButton(text: '$yearBuddhist', onTap: onYearTap),
          ],
        ],
      );
    }

    return Padding(
      padding: EdgeInsetsGeometry.zero,
      child: Stack(
        alignment: isSubPage ? Alignment.center : Alignment.centerLeft,
        children: [
          centerContent,
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: CustomColor.gray600),
              onPressed: () => NavigationService.instance.goBack(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownButton({required String text, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: CustomColor.gray300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: text,
              fontSize: Dimension.fontSizes.md,
              fontWeight: Dimension.fontWeights.regular,
              color: CustomColor.gray900,
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: CustomColor.gray900,
            ),
          ],
        ),
      ),
    );
  }

  // Title Header replace dropdown
  Widget _buildTitleHeader(String headerText) {
    return CustomText(
      text: headerText,
      fontSize: Dimension.fontSizes.h1,
      fontWeight: Dimension.fontWeights.bold,
      color: CustomColor.gray900,
    );
  }
}
