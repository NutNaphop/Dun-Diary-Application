import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/models/blood_pressure_graph_models.dart';
import 'package:intl/intl.dart';

/// Utility class สำหรับแปลง BPRecord เป็นข้อมูลกราฟ
///
/// รับผิดชอบ:
/// - Group ข้อมูลตามช่วงเวลา (Day/Week/Month)
/// - คำนวณค่าเฉลี่ยของแต่ละ group
/// - แปลงเป็น BloodPressureGraphData สำหรับ BpGraphSdk
class GraphDataMapper {
  // ===========================================================================
  // 🎯 Main Entry Point
  // ===========================================================================

  /// แปลง BPRecords เป็น GraphData ตาม tabIndex
  ///
  /// [records] - รายการ BPRecord (ไม่ต้อง sort มาก่อน)
  /// [tabIndex] - 0 = Week (รายวัน), 1 = Month (รายสัปดาห์), 2 = Year (รายเดือน)
  static List<BloodPressureGraphData> mapToGraphData(
    List<BPRecord> records,
    int tabIndex,
  ) {
    if (records.isEmpty) return [];

    // เรียงข้อมูลตามวันที่ก่อนเสมอ
    records.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    if (tabIndex == 0) {
      return _mapWeekly(records);
    } else if (tabIndex == 1) {
      return _mapMonthly(records);
    } else {
      return _mapYearly(records);
    }
  }

  // ===========================================================================
  // 📅 Weekly View: Group by Day
  // ===========================================================================

  /// Group ข้อมูลรายวัน (Day by Day)
  ///
  /// - xLabel: "13", "14", "15"
  /// - ถ้าวันนึงมีหลาย record → หาค่าเฉลี่ย
  static List<BloodPressureGraphData> _mapWeekly(List<BPRecord> records) {
    final Map<String, List<BPRecord>> grouped = {};

    for (var r in records) {
      final key = DateFormat('d').format(r.createdAt); // key = "13", "14"
      if (!grouped.containsKey(key)) grouped[key] = [];
      grouped[key]!.add(r);
    }

    return grouped.entries.map((entry) {
      final dailyRecords = entry.value;

      // หาค่าเฉลี่ยของวันนั้น
      final avgSys = BloodPressureUtils.calculateAVGSYS(
        dailyRecords.map((e) => e.sys).toList(),
      ).round();
      final avgDia = BloodPressureUtils.calculateAVGDIA(
        dailyRecords.map((e) => e.dia).toList(),
      ).round();

      // หา Level จากค่าเฉลี่ย
      final levelInt = BloodPressureUtils.calculateBloodPressureLevel(
        avgSys,
        avgDia,
      );

      return BloodPressureGraphData(
        xLabel: entry.key,
        level: _intToEnum(levelInt),
        sourceData: dailyRecords.last,
      );
    }).toList();
  }

  // ===========================================================================
  // 🗓️ Monthly View: Group by Week (จันทร์-อาทิตย์)
  // ===========================================================================

  /// Group ข้อมูลรายสัปดาห์ในเดือน
  ///
  /// - xLabel: "9-15", "16-22" (วันจันทร์-อาทิตย์ของสัปดาห์นั้น)
  /// - ใช้ ISO week (เริ่มจากวันจันทร์)
  static List<BloodPressureGraphData> _mapMonthly(List<BPRecord> records) {
    if (records.isEmpty) return [];

    final Map<String, List<BPRecord>> grouped = {};

    for (var r in records) {
      // หาวันจันทร์ของสัปดาห์นี้
      final weekStart = _getWeekStart(r.createdAt);
      // หาวันอาทิตย์ของสัปดาห์นี้
      final weekEnd = weekStart.add(const Duration(days: 6));

      // สร้าง key: "9-15"
      final key = "${weekStart.day}-${weekEnd.day}";

      if (!grouped.containsKey(key)) grouped[key] = [];
      grouped[key]!.add(r);
    }

    // เรียงตาม key (จากสัปดาห์แรกไปสุดท้าย)
    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) {
        final dayA = int.parse(a.key.split('-')[0]);
        final dayB = int.parse(b.key.split('-')[0]);
        return dayA.compareTo(dayB);
      });

    return sortedEntries.map((entry) {
      final list = entry.value;
      final avgSys = BloodPressureUtils.calculateAVGSYS(
        list.map((e) => e.sys).toList(),
      ).round();
      final avgDia = BloodPressureUtils.calculateAVGDIA(
        list.map((e) => e.dia).toList(),
      ).round();
      final levelInt = BloodPressureUtils.calculateBloodPressureLevel(
        avgSys,
        avgDia,
      );

      return BloodPressureGraphData(
        xLabel: entry.key,
        level: _intToEnum(levelInt),
        sourceData: list.first,
      );
    }).toList();
  }

  /// หาวันจันทร์ของสัปดาห์ที่ระบุ
  static DateTime _getWeekStart(DateTime date) {
    // weekday: 1 = Monday, 7 = Sunday
    final daysFromMonday = date.weekday - DateTime.monday;
    return DateTime(date.year, date.month, date.day - daysFromMonday);
  }

  // ===========================================================================
  // 📆 Yearly View: Group by Month
  // ===========================================================================

  /// Group ข้อมูลรายเดือน
  ///
  /// - xLabel: "ม.ค.", "ก.พ.", "มี.ค."
  static List<BloodPressureGraphData> _mapYearly(List<BPRecord> records) {
    final Map<String, List<BPRecord>> grouped = {};

    for (var r in records) {
      final key = DateTimeUtils.getMonthShort(r.createdAt.month);
      if (!grouped.containsKey(key)) grouped[key] = [];
      grouped[key]!.add(r);
    }

    return grouped.entries.map((entry) {
      final list = entry.value;
      final avgSys = BloodPressureUtils.calculateAVGSYS(
        list.map((e) => e.sys).toList(),
      ).round();
      final avgDia = BloodPressureUtils.calculateAVGDIA(
        list.map((e) => e.dia).toList(),
      ).round();
      final levelInt = BloodPressureUtils.calculateBloodPressureLevel(
        avgSys,
        avgDia,
      );

      return BloodPressureGraphData(
        xLabel: entry.key,
        level: _intToEnum(levelInt),
        sourceData: list.first,
      );
    }).toList();
  }

  // ===========================================================================
  // 🔧 Helper: Int → Enum Conversion
  // ===========================================================================

  /// แปลง level int (0-5) เป็น BloodPressureLevel enum
  static BloodPressureLevel _intToEnum(int level) {
    switch (level) {
      case 0:
        return BloodPressureLevel.low;
      case 1:
        return BloodPressureLevel.normal;
      case 2:
        return BloodPressureLevel.elevated;
      case 3:
        return BloodPressureLevel.highStage1;
      case 4:
        return BloodPressureLevel.highStage2;
      case 5:
        return BloodPressureLevel.crisis;
      default:
        return BloodPressureLevel.normal;
    }
  }
}
