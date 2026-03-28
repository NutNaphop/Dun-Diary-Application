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
  final DateTime? minDate;
  final DateTime? maxDate;

  const MonthPickerView({
    super.key,
    required this.selectedMonth,
    required this.selectedYear,
    required this.viewingYear,
    required this.onMonthSelected,
    this.minDate,
    this.maxDate,
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
        mainAxisSpacing: 10,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final monthIndex = index + 1;

        // Logic Future / Out of Range
        bool isDisabled = false;

        // Check Max Date (Future)
        if (maxDate != null) {
          // Compare as YYYY-MM
          final maxY = maxDate!.year;
          final maxM = maxDate!.month;
          if (viewingYear > maxY ||
              (viewingYear == maxY && monthIndex > maxM)) {
            isDisabled = true;
          }
        } else {
          // Default: Future check if maxDate not provided
          if (viewingYear > currentYear) {
            isDisabled = true;
          } else if (viewingYear == currentYear && monthIndex > currentMonth) {
            isDisabled = true;
          }
        }

        // Check Min Date (Past limit)
        if (minDate != null) {
          final minY = minDate!.year;
          final minM = minDate!.month;
          if (viewingYear < minY ||
              (viewingYear == minY && monthIndex < minM)) {
            isDisabled = true;
          }
        }

        final isSelected =
            monthIndex == selectedMonth && viewingYear == selectedYear;

        // Logic Current (เดือนปัจจุบันของปีปัจจุบัน)
        final isCurrent =
            (viewingYear == currentYear && monthIndex == currentMonth);

        return CalendarBaseCell(
          text: CalendarUtils.thaiMonths[monthIndex - 1],
          textColor: isDisabled ? CustomColor.gray300 : CustomColor.gray900,
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

          onTap: isDisabled ? null : () => onMonthSelected(monthIndex),
        );
      },
    );
  }
}
