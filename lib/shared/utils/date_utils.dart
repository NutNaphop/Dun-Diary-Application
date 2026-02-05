class DateTimeUtils {
  /// แปลง DateTime เป็น String รูปแบบ "ว/ด/ป(พ.ศ.)" เช่น 28/12/2568
  static String formatToThaiDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year + 543}";
  }

  /// แปลง DateTime เป็น String รูปแบบเวลา "HH:mm" เช่น 14:30
  static String formatToTime(DateTime date) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  static int getWeekOfYear(DateTime date) {
    // ใช้ package 'week_of_year' หรือคำนวณง่ายๆ หาร 7
    return ((date.dayOfYear - date.weekday + 10) / 7).floor();
  }

  static ({DateTime start, DateTime end, String key}) calculateDateRange(
    int index,
  ) {
    final now = DateTime.now();
    if (index == 0) {
      // Week
      return (
        start: now.subtract(Duration(days: 7)),
        end: now,
        key: "week_${now.year}_${getWeekOfYear(now)}",
      );
    } else if (index == 1) {
      // Month
      return (
        start: DateTime(now.year, now.month, 1),
        end: DateTime(now.year, now.month + 1, 0),
        key: "month_${now.year}_${now.month}",
      );
    }
    // Year
    return (
      start: DateTime(now.year, 1, 1),
      end: DateTime(now.year, 12, 31),
      key: "year_${now.year}",
    );
  }
}

extension DateUtils on DateTime {
  int get dayOfYear => int.parse("$month$day"); // แบบหยาบๆ ไปก่อนนะ
}
