import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/components/calendar_base_cell.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/utils/calendar_config.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/calendar_utils.dart';

class DayPickerView extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime focusedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;

  const DayPickerView({
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
      headerVisible: false,
      daysOfWeekHeight: 40,
      startingDayOfWeek: StartingDayOfWeek.monday,
      rowHeight: 45,
      enabledDayPredicate: (day) =>
          !CalendarUtils.isFuture(day) && day.month == focusedDay.month,
      onDaySelected: onDaySelected,
      onPageChanged: onPageChanged,
      selectedDayPredicate: (day) => isSameDay(day, selectedDate),

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
    bool isSelected = isSameDay(day, selectedDate);
    bool isToday = isSameDay(day, now);
    bool isFuture = CalendarUtils.isFuture(day);
    bool isOutside = day.month != focusedDay.month;

    Color backgroundColor = isSelected && !isOutside
        ? CustomColor.secondaryColor
        : Colors.transparent;

    Color textColor;
    if (isOutside || isFuture) {
      textColor = CustomColor.gray500;
    } else if (isSelected) {
      textColor = CustomColor.gray900;
    } else {
      textColor = CustomColor.gray900;
    }

    return CalendarBaseCell(
      text: '${day.day}',
      textColor: textColor,
      backgroundColor: backgroundColor,
      isToday: isToday,
      shape: BoxShape.circle,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      dotOffset: 1,
      fontWeight: FontWeight.normal,
    );
  }
}
