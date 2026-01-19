import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/calendar_utils.dart';

class WeekPickerView extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime focusedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;

  const WeekPickerView({
    super.key,
    required this.selectedDate,
    required this.focusedDay,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return TableCalendar(
      locale: 'th_TH',
      firstDay: DateTime(now.year - 100, 1, 1),
      lastDay: DateTime(now.year + 10, 12, 31), // ปล่อย lastDay ยาวๆ
      focusedDay: focusedDay,
      currentDay: now,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerVisible: false,
      daysOfWeekHeight: 40,
      rowHeight: 52,

      // กดได้ถ้าไม่ใช่อนาคต หรือ เป็นสัปดาห์ปัจจุบัน
      enabledDayPredicate: (day) {
        bool isFuture = CalendarUtils.isFuture(day);
        bool isCurrentWeek = CalendarUtils.isSameWeek(day, now);
        return !isFuture || isCurrentWeek;
      },

      onDaySelected: onDaySelected,
      onPageChanged: onPageChanged,
      selectedDayPredicate: (day) =>
          CalendarUtils.isSameWeek(day, selectedDate),

      calendarStyle: const CalendarStyle(
        outsideDaysVisible: true,
        isTodayHighlighted: false,
        markersMaxCount: 0,
      ),

      calendarBuilders: CalendarBuilders(
        prioritizedBuilder: (context, day, focusedDay) {
          return _buildCustomDayCell(day);
        },
      ),
    );
  }

  Widget _buildCustomDayCell(DateTime day) {
    final now = DateTime.now();
    bool isSelectedWeek = CalendarUtils.isSameWeek(day, selectedDate);
    bool isToday = CalendarUtils.isSameDay(day, now);
    bool isFuture = CalendarUtils.isFuture(day);

    // เช็คเพิ่ม: วันนี้อยู่ในสัปดาห์ปัจจุบันหรือไม่?
    bool isCurrentWeekContext = CalendarUtils.isSameWeek(day, now);

    // Logic หัวท้ายมน
    BorderRadiusGeometry borderRadius = BorderRadius.zero;
    if (isSelectedWeek) {
      if (day.weekday == DateTime.monday) {
        borderRadius = const BorderRadius.horizontal(left: Radius.circular(50));
      } else if (day.weekday == DateTime.sunday) {
        borderRadius = const BorderRadius.horizontal(
          right: Radius.circular(50),
        );
      }
    }

    Color backgroundColor = isSelectedWeek
        ? CustomColor.secondaryColor
        : Colors.transparent;

    // *** แก้ไข Logic สีตัวอักษร ***
    Color textColor;

    // เงื่อนไข 1: เป็นอนาคต "ของสัปดาห์อื่น" (ที่ไม่ใช่วีคปัจจุบัน) -> สีเทา
    if (isFuture && !isCurrentWeekContext) {
      textColor = CustomColor.gray400;
    }
    // เงื่อนไข 2: ถูกเลือกอยู่ (รวมถึงอนาคตของวีคนี้ด้วย) -> สีเขียวเข้ม
    else if (isSelectedWeek) {
      textColor = CustomColor.gray900;
    }
    // เงื่อนไข 3: วันปกติทั่วไป -> สีดำ
    else {
      textColor = CustomColor.gray900;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: CustomText(
              text: '${day.day}',
              color: textColor,
              fontSize: Dimension.fontSizes.md,
              fontWeight: isSelectedWeek
                  ? Dimension.fontWeights.bold
                  : Dimension.fontWeights.regular,
            ),
          ),

          if (isToday)
            Positioned(
              bottom: 8,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
