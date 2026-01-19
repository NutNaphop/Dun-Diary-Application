import 'package:flutter/material.dart';

class CalendarUtils {
  // ชื่อเดือนภาษาไทย
  static const List<String> thaiMonths = [
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฎาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม',
  ];

  // สูตรแปลง ค.ศ. -> พ.ศ.
  static int toBuddhistYear(int adYear) => adYear + 543;

  // แปลงกลับ พ.ศ. -> ค.ศ. (เผื่อใช้ตอน save)
  static int toADYear(int buddhistYear) => buddhistYear - 543;

  // เช็คว่าเป็นวันในอนาคตหรือไม่ (กฎเหล็กของเรา)
  static bool isFuture(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return date.isAfter(today);
  }

  static String formatMonthYear(DateTime date) {
    return '${thaiMonths[date.month - 1]} ${toBuddhistYear(date.year)}';
  }
  
  // Helper สำหรับดึงวันแรกและวันสุดท้ายของสัปดาห์ (ใช้ใน Week View)
  static DateTimeRange getWeekRange(DateTime date) {
    // หาว่าวันจันทร์ของสัปดาห์นี้คือวันไหน (weekday 1 = Mon)
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    // ตัดเวลาทิ้ง (normalize) ให้เหลือแค่ 00:00:00
    return DateTimeRange(
      start: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      end: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day),
    );
  }

  // เช็คว่า day1 และ day2 อยู่ในสัปดาห์เดียวกันหรือไม่
  static bool isSameWeek(DateTime day1, DateTime day2) {
    // หาวันจันทร์ของทั้งคู่
    final start1 = day1.subtract(Duration(days: day1.weekday - 1));
    final start2 = day2.subtract(Duration(days: day2.weekday - 1));

    // ตัดเวลาทิ้งแล้วเทียบกัน
    return isSameDay(start1, start2);
  }

  // (Optional) Helper ของ table_calendar เผื่อยังไม่ได้ import
  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
