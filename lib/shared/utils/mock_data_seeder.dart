import 'dart:math';
import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:uuid/uuid.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';

class MockDataSeeder {
  final BloodPressureRepository _repo;

  MockDataSeeder(this._repo);

  Future<void> generateBigData() async {
    AppLogger.info("Start Seeding Data...");
    final random = Random();
    final uuid = Uuid();

    // เริ่มจากวันนี้ (ปัจจุบัน) แล้วย้อนหลัง 3 ปี
    final startDate = DateTime.now();
    const int totalDays = 365 * 3; // 3 ปี (~1095 วัน)

    // วนลูปย้อนหลัง 3 ปี
    for (int i = 0; i < totalDays; i++) {
      // สร้างวันที่ย้อนหลังจาก startDate (วันนี้ - i วัน)
      final date = startDate.subtract(Duration(days: i));

      // สุ่มว่าวันนี้จะวัดกี่ครั้ง (1 - 3 ครั้ง) - การันตีอย่างน้อย 1 ครั้ง
      int dailyCount = 1 + random.nextInt(3);

      for (int j = 0; j < dailyCount; j++) {
        // สุ่มเวลาในวันนั้น (เช่น 8:00 - 20:00)
        final time = date.add(
          Duration(hours: 8 + random.nextInt(12), minutes: random.nextInt(60)),
        );

        // สุ่มค่าความดันแบบการแจกแจงปกติ (Normal Distribution) 
        // ให้ค่าส่วนใหญ่อยู่ในเกณฑ์ปกติ แต่มีเล็กน้อยที่แกว่งไปมาดูสมจริง
        final sys = _generateNormalInt(random, 115, 8).clamp(90, 180); // จะเกาะกลุ่มแถว 107-123 เป็นส่วนใหญ่
        final dia = _generateNormalInt(random, 75, 5).clamp(60, 110);  // จะเกาะกลุ่มแถว 70-80 เป็นส่วนใหญ่
        final pulse = _generateNormalInt(random, 75, 8).clamp(50, 120); // จะเกาะกลุ่มแถว 67-83 เป็นส่วนใหญ่

        final record = BPRecord(
          id: uuid.v4(),
          ownerId: uuid.v4(),
          sys: sys,
          dia: dia,
          pulse: pulse,
          createdAt: time,
          note: "Mock Data",
        );

        // ✅ สำคัญ: ต้อง save ผ่าน Repo เท่านั้น!
        // เพื่อให้มันไปอัปเดต "Index Box" (สารบัญรายเดือน) ให้อัตโนมัติ
        await _repo.saveRecord(record, false);
      }
    }
    AppLogger.info("Seeding Complete! Enjoy your data.");
  }

  /// สุ่มค่าด้วยการแจกแจงแบบปกติ (Normal Distribution - Box-Muller transform)
  int _generateNormalInt(Random random, double mean, double stdDev) {
    double u1 = 1.0 - random.nextDouble(); // (0, 1]
    double u2 = 1.0 - random.nextDouble(); // (0, 1]
    double randStdNormal = sqrt(-2.0 * log(u1)) * sin(2.0 * pi * u2); // Normal(0, 1)
    return (mean + stdDev * randStdNormal).round();
  }
}
