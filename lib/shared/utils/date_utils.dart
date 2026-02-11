import 'package:intl/intl.dart';

/// Utility class สำหรับจัดการ DateTime และการคำนวณช่วงเวลา
///
/// รับผิดชอบ:
/// - แปลง DateTime เป็นรูปแบบต่างๆ (ไทย, เวลา)
/// - คำนวณ Date Range สำหรับ Week/Month/Year view
/// - สร้าง Label สำหรับแสดงผล
class DateTimeUtils {
  /// แปลง DateTime เป็น Key ปี_เดือน เช่น "2024_01" (ใช้สำหรับ Cache / Query)
  static String getYearMonthKey(DateTime date) {
    return "${date.year}_${date.month.toString().padLeft(2, '0')}";
  }

  /// แสดง Label เวลาสำหรับหน้า History
  /// - วันนี้: "ล่าสุด HH:mm"
  /// - วันอื่น: "บันทึกครั้งสุดท้ายเมื่อ HH:mm"
  /// - ไม่มีข้อมูล: "-"
  static String getHistoryTimeLabel(DateTime? date) {
    if (date == null) return "-";

    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final timeStr =
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

    if (isToday) {
      return "ล่าสุด $timeStr";
    } else {
      return "บันทึกครั้งสุดท้ายเมื่อ $timeStr";
    }
  }
  // ===========================================================================
  // 📅 SECTION 1: Date Formatting
  // ===========================================================================

  /// แปลง DateTime เป็น String รูปแบบ "ว/ด/ป(พ.ศ.)" เช่น 28/12/2568
  static String formatToThaiDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year + 543}";
  }

  /// แปลง DateTime เป็น String รูปแบบ "ว/ด/ป(พ.ศ.) HH:mm" เช่น 28/12/2568 14:30
  static String formatToThaiDateWithTime(DateTime date) {
    return "${date.day}/${date.month}/${date.year + 543} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  /// แปลงเป็น String แบบ 1 มกราคม 2567
  static String formatToThaiDateFull(DateTime date) {
    return "${date.day} ${getMonthFull(date.month)} ${date.year + 543}";
  }

  /// แปลงเป็น String แบบ 1 มกราคม 2567 14:30
  static String formatToThaiDateFullWithTime(DateTime date) {
    return "${date.day} ${getMonthFull(date.month)} ${date.year + 543} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  /// แปลง DateTime เป็น String รูปแบบเวลา "HH:mm" เช่น 14:30
  static String formatToTime(DateTime date) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  /// คำนวณ Week Number (1-52) ตามมาตรฐาน ISO 8601
  static int getWeekOfYear(DateTime date) {
    return ((date.dayOfYear - date.weekday + 10) / 7).floor();
  }

  // ===========================================================================
  // 📆 SECTION 2: Date Range Calculation
  // ===========================================================================

  /// คำนวณช่วงเวลา (start - end) โดยอิงจาก anchorDate
  ///
  /// [index] - 0 = Week, 1 = Month, 2 = Year
  /// [anchorDate] - วันที่อ้างอิง
  ///
  /// Returns:
  /// - start: วันเริ่มต้นของช่วง
  /// - end: วันสิ้นสุดของช่วง (23:59:59)
  /// - key: unique key สำหรับ cache (เช่น "week_2024_5")
  ///
  /// Week: จันทร์ 00:00:00 - อาทิตย์ 23:59:59
  /// Month: วันที่ 1 00:00:00 - วันสุดท้ายของเดือน 23:59:59
  /// Year: 1 ม.ค. 00:00:00 - 31 ธ.ค. 23:59:59
  static ({DateTime start, DateTime end, String key}) calculateDateRange(
    int index,
    DateTime anchorDate,
  ) {
    if (index == 0) {
      // [Week] หาวันจันทร์ของสัปดาห์นี้
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
      // [Month] วันที่ 1 ถึงวันสิ้นเดือน
      final start = DateTime(anchorDate.year, anchorDate.month, 1);
      final end = DateTime(
        anchorDate.year,
        anchorDate.month + 1,
        0, // Day 0 = วันสุดท้ายของเดือนก่อนหน้า
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
      // [Year] 1 ม.ค. - 31 ธ.ค.
      final start = DateTime(anchorDate.year, 1, 1);
      final end = DateTime(anchorDate.year, 12, 31, 23, 59, 59);

      return (start: start, end: end, key: "year_${start.year}");
    }
  }

  // ===========================================================================
  // 🏷️ SECTION 3: Label Generation
  // ===========================================================================

  /// สร้าง Label แสดงช่วงเวลาสำหรับ UI
  ///
  /// Examples:
  /// - Week: "3 ก.พ. - 9 ก.พ. 2569"
  /// - Month: "กุมภาพันธ์ 2569"
  /// - Year: "ปี 2569"
  static String getRangeLabel(int index, DateTime anchorDate) {
    final range = calculateDateRange(index, anchorDate);
    final start = range.start;
    final end = range.end;

    if (index == 0) {
      // Week: "3 ก.พ. - 9 ก.พ. 2569"
      return "${start.day} ${getMonthShort(start.month)} - ${end.day} ${getMonthShort(end.month)} ${end.year + 543}";
    } else if (index == 1) {
      // Month: "กุมภาพันธ์ 2569"
      return "${getMonthFull(anchorDate.month)} ${anchorDate.year + 543}";
    } else {
      // Year: "ปี 2569"
      return "ปี ${anchorDate.year + 543}";
    }
  }

  // ===========================================================================
  // 🔤 SECTION 4: Thai Month Names
  // ===========================================================================

  /// แปลงเลขเดือน (1-12) เป็นชื่อเดือนไทย (ย่อ)
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

  /// แปลงเลขเดือน (1-12) เป็นชื่อเดือนไทย (เต็ม)
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

  static String getDayName(int weekday) {
    const days = ["จ", "อ", "พ", "พฤ", "ศ", "ส", "อา"];
    return days[weekday - 1];
  }
}

/// Extension เพื่อเพิ่ม dayOfYear property ให้ DateTime
extension DateUtils on DateTime {
  /// คำนวณลำดับวันในปี (1-365/366)
  int get dayOfYear => int.parse(DateFormat("D").format(this));
}
