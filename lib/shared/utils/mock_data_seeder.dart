import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';

class MockDataSeeder {
  final BloodPressureRepository _repo;

  MockDataSeeder(this._repo);

  Future<void> generateBigData() async {
    print("🚀 Start Seeding Data...");
    final random = Random();
    final uuid = Uuid();

    // เริ่มจากสิ้นปี 2569 (2026 ค.ศ.) แล้วย้อนหลัง 3 ปี
    final startDate = DateTime(2026, 12, 31);
    const int totalDays = 365 * 3; // 3 ปี (~1095 วัน)

    // วนลูปย้อนหลัง 3 ปี
    for (int i = 0; i < totalDays; i++) {
      // สุ่มว่าวันนี้จะวัดกี่ครั้ง (1 - 3 ครั้ง) - การันตีอย่างน้อย 1 ครั้ง
      int dailyCount = 1 + random.nextInt(3);

      for (int j = 0; j < dailyCount; j++) {
        // สร้างวันที่ย้อนหลังจาก startDate
        final date = startDate.subtract(Duration(days: i));

        // สุ่มเวลาในวันนั้น (เช่น 8:00 - 20:00)
        final time = date.add(
          Duration(hours: 8 + random.nextInt(12), minutes: random.nextInt(60)),
        );

        // สุ่มค่าความดัน (ให้มีแกว่งๆ บ้าง)
        final sys = 110 + random.nextInt(30); // 110 - 140
        final dia = 70 + random.nextInt(20); // 70 - 90
        final pulse = 60 + random.nextInt(40); // 60 - 100

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
    print("✅ Seeding Complete! Enjoy your data.");
  }
}
