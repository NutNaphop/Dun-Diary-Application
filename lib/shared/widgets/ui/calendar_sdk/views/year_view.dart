// lib/shared/widgets/ui/calendar_sdk/views/year_view.dart

import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/components/calendar_base_cell.dart';
import 'package:flutter/material.dart';
import '../utils/calendar_utils.dart';

class YearPickerView extends StatelessWidget {
  final int selectedYear;
  final Function(int) onYearSelected;

  const YearPickerView({
    super.key,
    required this.selectedYear,
    required this.onYearSelected,
  });

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final startYear = currentYear - 5;
    final totalYears = 7;


    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 40,
        mainAxisSpacing: 20,
      ),
      itemCount: totalYears,
      itemBuilder: (context, index) {
        final int year = startYear + index;

        final isSelected = year == selectedYear;
        final isFuture = year > currentYear;

        // Logic Current (ปีปัจจุบัน)
        final isCurrent = year == currentYear;

        // ใช้ Component ใหม่ (Reused)
        return CalendarBaseCell(
          text: '${CalendarUtils.toBuddhistYear(year)}', // แสดงปี พ.ศ.
          textColor: isFuture ? CustomColor.gray500 : CustomColor.gray900,
          backgroundColor: isSelected
              ? CustomColor.secondaryColor
              : Colors.transparent,
          isToday: isCurrent, // ปีปัจจุบัน

          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),

          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          dotOffset: -8,

          onTap: isFuture ? null : () => onYearSelected(year),
        );
      },
    );
  }
}
