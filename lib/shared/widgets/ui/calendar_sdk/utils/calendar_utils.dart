import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/calendar_types.dart';

class CalendarUtils {
  // ชื่อเดือนภาษาไทย
  static List<String> thaiMonths = [
    AppStrings.calendar.january,
    AppStrings.calendar.february,
    AppStrings.calendar.march,
    AppStrings.calendar.april,
    AppStrings.calendar.may,
    AppStrings.calendar.june,
    AppStrings.calendar.july,
    AppStrings.calendar.august,
    AppStrings.calendar.september,
    AppStrings.calendar.october,
    AppStrings.calendar.november,
    AppStrings.calendar.december,
  ];

  // สูตรแปลง ค.ศ. -> พ.ศ.
  static int toBuddhistYear(int adYear) => adYear + 543;

  // แปลงกลับ พ.ศ. -> ค.ศ. (เผื่อใช้ตอน save)
  static int toADYear(int buddhistYear) => buddhistYear - 543;

  // เช็คว่าเป็นวันในอนาคตหรือไม่ (กฎเหล็กของเรา)
  static bool isFuture(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);
    return checkDate.isAfter(today);
  }

  // เช็คว่า day1 และ day2 อยู่ในสัปดาห์เดียวกันหรือไม่
  static bool isSameWeek(DateTime day1, DateTime day2) {
    // หาวันจันทร์ของทั้งคู่
    final start1 = day1.subtract(Duration(days: day1.weekday - 1));
    final start2 = day2.subtract(Duration(days: day2.weekday - 1));

    // ตัดเวลาทิ้งแล้วเทียบกัน
    return isSameDay(start1, start2);
  }

  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String formatMonthYear(DateTime date) {
    return '${thaiMonths[date.month - 1]} ${toBuddhistYear(date.year)}';
  }

  // Helper สำหรับดึงวันแรกและวันสุดท้ายของสัปดาห์ (ใช้ใน Week View)
  static DateTimeRange getWeekRange(DateTime date) {
    // ใช้ getCustomWeekRange เพื่อให้ Logic การคำนวณเป็นมาตรฐานเดียวกัน
    return getCustomWeekRange(date, startDayOfWeek: DateTime.monday);
  }

  // Helper สำหรับจัดการวันที่ไม่ให้เกินจำนวนวันในเดือน (เช่น 31 ก.พ. -> 28 ก.พ.)
  static DateTime clampDay(int year, int month, int day) {
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final clampedDay = day > daysInMonth ? daysInMonth : day;
    return DateTime(year, month, clampedDay);
  }

  /// หาช่วงวันที่ของสัปดาห์ (Start - End) โดยอิงจากวันที่ส่งเข้ามา
  static DateTimeRange getCustomWeekRange(
    DateTime date, {
    int startDayOfWeek = DateTime.monday,
  }) {
    // 1. คำนวณหาว่าต้องย้อนกลับไปกี่วันถึงจะเจอวันเริ่มสัปดาห์
    int daysToSubtract = (date.weekday - startDayOfWeek + 7) % 7;

    // 2. หาวันเริ่มต้น (ตัดเวลาทิ้งให้เหลือแค่ 00:00:00)
    DateTime start = DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: daysToSubtract));

    // 3. หาวันสิ้นสุด (บวกไปอีก 6 วัน)
    DateTime end = start.add(const Duration(days: 6));
    return DateTimeRange(start: start, end: end);
  }

  // Debug Function
  static String debugRange(DateTimeRange range) {
    String f(DateTime d) =>
        "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${toBuddhistYear(d.year)}";
    return "Start: ${f(range.start)} | End: ${f(range.end)}";
  }

  static String formatWeekRange(DateTime date) {
    final start = date.subtract(
      Duration(days: date.weekday - 1),
    ); // หาวันจันทร์
    final end = start.add(const Duration(days: 6)); // หาวันอาทิตย์

    final df = DateFormat('d', 'th'); // วันที่
    final mf = DateFormat('MMMM', 'th'); // เดือนเต็ม
    final y = CalendarUtils.toBuddhistYear(date.year);

    // กรณีข้ามเดือน
    if (start.month != end.month) {
      final mfStart = DateFormat('MMM', 'th'); // เดือนย่อ
      final mfEnd = DateFormat('MMM', 'th');
      return "${df.format(start)} ${mfStart.format(start)} - ${df.format(end)} ${mfEnd.format(end)} $y";
    }

    // กรณีเดือนเดียวกัน
    return "${df.format(start)} - ${df.format(end)} ${mf.format(end)} $y";
  }

  // Helper สำหรับข้อความปุ่ม "ไปที่..."
  static String getTodayButtonText(CalendarType type) {
    switch (type) {
      case CalendarType.year:
        return AppStrings.calendar.selectPresentYear;
      case CalendarType.month:
        return AppStrings.calendar.selectPresentMonth;
      case CalendarType.week:
        return AppStrings.calendar.selectPresentWeek;
      case CalendarType.day:
        return AppStrings.calendar.selectPresentDay;
    }
  }

  static CalendarHeaderStyle getHeaderStyle(CalendarView currentView) {
    switch (currentView) {
      case CalendarView.day:
        return CalendarHeaderStyle.day;
      case CalendarView.week:
        return CalendarHeaderStyle.week;
      case CalendarView.month:
        return CalendarHeaderStyle.month;
      case CalendarView.year:
        return CalendarHeaderStyle.year;
    }
  }

  static bool isSubPage(CalendarType calendarType, CalendarView currentView) {
    switch (calendarType) {
      case CalendarType.day:
        return currentView != CalendarView.day;
      case CalendarType.week:
        return currentView != CalendarView.week;
      case CalendarType.month:
        return currentView != CalendarView.month;
      case CalendarType.year:
        return currentView != CalendarView.year;
    }
  }

  /// Maps tab index to CalendarType (0=week, 1=month, 2=year)
  static CalendarType getCalendarTypeFromTabIndex(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return CalendarType.week;
      case 1:
        return CalendarType.month;
      case 2:
        return CalendarType.year;
      default:
        return CalendarType.week;
    }
  }
}
