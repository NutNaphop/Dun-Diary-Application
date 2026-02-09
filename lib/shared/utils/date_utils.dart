import 'package:intl/intl.dart';

class DateTimeUtils {
  /// แปลง DateTime เป็น String รูปแบบ "ว/ด/ป(พ.ศ.)" เช่น 28/12/2568
  static String formatToThaiDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year + 543}";
  }

  /// แปลง DateTime เป็น String รูปแบบเวลา "HH:mm" เช่น 14:30
  static String formatToTime(DateTime date) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  /// คำนวณ Week Number (1-52)
  static int getWeekOfYear(DateTime date) {
    return ((date.dayOfYear - date.weekday + 10) / 7).floor();
  }

  // -------------------------------------------------------------------------
  // 🟢 1. Logic คำนวณช่วงเวลา (Start - End) โดยอิงจาก anchorDate
  // -------------------------------------------------------------------------
  static ({DateTime start, DateTime end, String key}) calculateDateRange(
    int index,
    DateTime anchorDate, // ✅ รับวันอ้างอิงเข้ามา (แทนการใช้ DateTime.now())
  ) {
    if (index == 0) {
      int daysToSubtract = anchorDate.weekday - DateTime.monday;
      DateTime weekStart = anchorDate.subtract(Duration(days: daysToSubtract));

      final start = DateTime(
        weekStart.year,
        weekStart.month,
        weekStart.day,
        0,
        0,
        0,
      );
      final end = DateTime(
        weekStart.year,
        weekStart.month,
        weekStart.day + 6, // อาทิตย์
        23,
        59,
        59,
      );

      return (
        start: start,
        end: end,
        key: "week_${start.year}_${getWeekOfYear(start)}",
      );
    } else if (index == 1) {
      // [Month] : วันที่ 1 ถึงวันสิ้นเดือน ของเดือน anchorDate
      final start = DateTime(anchorDate.year, anchorDate.month, 1);
      final end = DateTime(
        anchorDate.year,
        anchorDate.month + 1,
        0,
        23,
        59,
        59,
      );

      return (
        start: start,
        end: end,
        key: "month_${start.year}_${start.month}",
      );
    } else {
      // [Year] : 1 ม.ค. - 31 ธ.ค.
      final start = DateTime(anchorDate.year, 1, 1);
      final end = DateTime(anchorDate.year, 12, 31, 23, 59, 59);

      return (start: start, end: end, key: "year_${start.year}");
    }
  }

  // -------------------------------------------------------------------------
  // 🟢 2. Helper สร้างข้อความหัวข้อ (Range Label)
  // -------------------------------------------------------------------------
  static String getRangeLabel(int index, DateTime anchorDate) {
    // คำนวณช่วงเวลาก่อน เพื่อเอาวันที่ start/end มาโชว์
    final range = calculateDateRange(index, anchorDate);
    final start = range.start;
    final end = range.end;

    if (index == 0) {
      // Week
      return "${start.day} ${getMonthShort(start.month)} - ${end.day} ${getMonthShort(end.month)} ${end.year + 543}";
    } else if (index == 1) {
      // Month
      return "${getMonthFull(anchorDate.month)} ${anchorDate.year + 543}";
    } else {
      // Year
      return "ปี ${anchorDate.year + 543}";
    }
  }

  // Helper แปลงชื่อเดือนไทย (ย่อ)
  static String getMonthShort(int month) {
    const months = [
      "ม.ค.",
      "ก.พ.",
      "มี.ค.",
      "เม.ย.",
      "พ.ค.",
      "มิ.ย.",
      "ก.ค.",
      "ส.ค.",
      "ก.ย.",
      "ต.ค.",
      "พ.ย.",
      "ธ.ค.",
    ];
    return months[month - 1];
  }

  // Helper แปลงชื่อเดือนไทย (เต็ม)
  static String getMonthFull(int month) {
    const months = [
      "มกราคม",
      "กุมภาพันธ์",
      "มีนาคม",
      "เมษายน",
      "พฤษภาคม",
      "มิถุนายน",
      "กรกฎาคม",
      "สิงหาคม",
      "กันยายน",
      "ตุลาคม",
      "พฤศจิกายน",
      "ธันวาคม",
    ];
    return months[month - 1];
  }
}

extension DateUtils on DateTime {
  int get dayOfYear => int.parse(DateFormat("D").format(this));
}
