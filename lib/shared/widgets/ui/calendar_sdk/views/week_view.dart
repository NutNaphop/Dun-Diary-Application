import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/components/calendar_base_cell.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/utils/calendar_config.dart';
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
      locale: CalendarConfig.locale,
      firstDay: CalendarConfig.firstDay,
      lastDay: CalendarConfig.lastDay,
      focusedDay: focusedDay,
      currentDay: now,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerVisible: false,
      daysOfWeekHeight: 40,
      rowHeight: 52,
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
    bool isOutside = day.month != focusedDay.month;
    bool isCurrentWeekContext = CalendarUtils.isSameWeek(day, now);

    // ตรวจสอบว่าวันนี้น่าจะกดได้หรือไม่ (สอดคล้องกับ enabledDayPredicate)
    bool isEnabled = !isFuture || isCurrentWeekContext;

    // Background Hilight
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
    if (!isEnabled || isOutside) {
      textColor = CustomColor.gray400;
    }
    else if (isSelectedWeek) {
      textColor = CustomColor.gray900;
    }
    else {
      textColor = CustomColor.gray900;
    }

    return CalendarBaseCell(
      text: '${day.day}',
      textColor: textColor,
      backgroundColor: backgroundColor,
      isToday: isToday,
      shape: BoxShape.rectangle,
      borderRadius: borderRadius,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      dotOffset: 1,
      fontWeight: isSelectedWeek ? FontWeight.bold : FontWeight.normal,
    );
  }
}
