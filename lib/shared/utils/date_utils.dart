

class DateTimeUtils {
  /// แปลง DateTime เป็น String รูปแบบ "ว/ด/ป(พ.ศ.)" เช่น 28/12/2568
  static String formatToThaiDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year + 543}";
  }

  /// แปลง DateTime เป็น String รูปแบบเวลา "HH:mm" เช่น 14:30
  static String formatToTime(DateTime date) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}