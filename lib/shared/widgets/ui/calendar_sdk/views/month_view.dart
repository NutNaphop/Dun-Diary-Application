// lib/shared/widgets/ui/calendar_sdk/views/month_view.dart

import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/components/calendar_base_cell.dart';
import 'package:flutter/material.dart';

import '../utils/calendar_utils.dart';

class MonthPickerView extends StatelessWidget {
  final int selectedMonth;
  final int selectedYear;
  final int viewingYear;
  final Function(int) onMonthSelected;

  const MonthPickerView({
    super.key,
    required this.selectedMonth,
    required this.selectedYear,
    required this.viewingYear,
    required this.onMonthSelected,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 40,
        mainAxisSpacing: 20,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final monthIndex = index + 1;

        // Logic Future
        bool isFuture = false;
        if (viewingYear > currentYear) {
          isFuture = false;
        } else if (viewingYear == currentYear && monthIndex > currentMonth) {
          isFuture = false;
        }

        final isSelected =
            monthIndex == selectedMonth && viewingYear == selectedYear;

        // Logic Current (เดือนปัจจุบันของปีปัจจุบัน)
        final isCurrent =
            (viewingYear == currentYear && monthIndex == currentMonth);

        return CalendarBaseCell(
          text: CalendarUtils.thaiMonths[monthIndex - 1],
          textColor: isFuture ? CustomColor.gray500 : CustomColor.gray900,
          backgroundColor: isSelected
              ? CustomColor.secondaryColor
              : Colors.transparent,
          isToday: isCurrent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 2,
          ), // ทำแคปซูล
          // margin: const EdgeInsets.only(bottom: 8),
          dotOffset: -8, // ยัด Offset 0 ให้จุดติดขอบล่างสุด (ใต้แคปซูล)

          onTap: isFuture ? null : () => onMonthSelected(monthIndex),
        );
      },
    );
  }
}
