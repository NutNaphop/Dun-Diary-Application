import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart'; // import utils เดิมของคุณ
import 'package:dun_diary_app/shared/utils/date_utils.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/models/blood_pressure_graph_models.dart';
import 'package:intl/intl.dart'; // อย่าลืมลง package intl นะครับ เพื่อจัด format วันที่

class GraphDataMapper {
  // ฟังก์ชันหลักที่ ViewModel จะเรียกใช้
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

  // ------------------------------------------------------------------
  // 📅 1. Weekly: โชว์รายวัน (Day by Day)
  // ------------------------------------------------------------------
  static List<BloodPressureGraphData> _mapWeekly(List<BPRecord> records) {
    // Group ตามวัน (เผื่อวันนึงวัดหลายรอบ ให้หาค่าเฉลี่ยของวันนั้น)
    final Map<String, List<BPRecord>> grouped = {};

    for (var r in records) {
      final key = DateFormat('d').format(r.createdAt); // key = "13", "14"
      if (!grouped.containsKey(key)) grouped[key] = [];
      grouped[key]!.add(r);
    }

    return grouped.entries.map((entry) {
      final dailyRecords = entry.value;

      // หาค่าเฉลี่ยของวันนั้น (ใช้ Utils คุณช่วยคิด)
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
        xLabel: entry.key, // "13", "14"
        level: _intToEnum(levelInt), // แปลง int เป็น Enum
        sourceData: dailyRecords.last, // หรือจะส่ง avgSys ไปก็ได้แล้วแต่ design
      );
    }).toList();
  }

  // ------------------------------------------------------------------
  // 🗓️ 2. Monthly: โชว์รายสัปดาห์ (Week 1, Week 2...)
  // ------------------------------------------------------------------
  static List<BloodPressureGraphData> _mapMonthly(List<BPRecord> records) {
    // แบ่งเป็น 4-5 ช่วง (1-7, 8-14, 15-21, 22-สิ้นเดือน)
    final Map<String, List<BPRecord>> grouped = {};

    for (var r in records) {
      final day = r.createdAt.day;
      String key;
      if (day <= 7)
        key = "1-7";
      else if (day <= 14)
        key = "8-14";
      else if (day <= 21)
        key = "15-21";
      else if (day <= 28)
        key = "22-28";
      else
        key = "29+";

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
        sourceData: list.first, // Dummy source
      );
    }).toList();
  }

  // ------------------------------------------------------------------
  // 📆 3. Yearly: โชว์รายเดือน (Jan, Feb...)
  // ------------------------------------------------------------------
  static List<BloodPressureGraphData> _mapYearly(List<BPRecord> records) {
    final Map<String, List<BPRecord>> grouped = {};

    for (var r in records) {
      final key = DateTimeUtils.getMonthShort(
        r.createdAt.month,
      ); // "ม.ค.", "ก.พ."
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

  static BloodPressureLevel _intToEnum(int level) {
    switch (level) {
      case 0:
        return BloodPressureLevel.low;
      case 1:
        return BloodPressureLevel.normal;
      case 2:
        return BloodPressureLevel.preHigh;
      case 3:
        return BloodPressureLevel.high;
      case 4:
        return BloodPressureLevel.veryHigh;
      default:
        return BloodPressureLevel.normal;
    }
  }
}
