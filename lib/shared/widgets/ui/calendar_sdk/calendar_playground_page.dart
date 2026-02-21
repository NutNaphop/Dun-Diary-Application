import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/data/blood_pressure/datasource/blood_pressure_local_data_source.dart';
import 'package:dun_diary_app/data/blood_pressure/datasource/blood_pressure_remote_data_source.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/calendar_sdk.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/models/calendar_types.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/utils/calendar_utils.dart';
import 'package:flutter/material.dart';

class CalendarPlaygroundPage extends StatefulWidget {
  const CalendarPlaygroundPage({super.key});

  @override
  State<CalendarPlaygroundPage> createState() => _CalendarPlaygroundPageState();
}

class _CalendarPlaygroundPageState extends State<CalendarPlaygroundPage> {
  // --- 1. แยกตัวแปรเก็บค่าของใครของมัน ---
  DateTime? _dayDate; // เก็บค่าวันของ Day Picker
  DateTime? _weekDate; // เก็บค่าวันของ Week Picker
  DateTime? _monthDate; // เก็บค่าวันของ Month Picker
  DateTime? _yearDate; // เก็บค่าวันของ Year Picker
  DateTimeRange? _weekRange; // เก็บค่าช่วงวันของ Week Finder
  DateTime? _weekFinderDate; // วันที่ใช้สำหรับทดสอบหาช่วงสัปดาห์

  final _repository = BloodPressureRepository(
    localDataSource: BloodPressureLocalDataSource(),
    remoteDataSource: BloodPressureRemoteDataSource(
      firestore: FirebaseFirestore.instance,
    ),
    authService: AuthService(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🗓️ Caledar SDK Playground'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- ZONE 0: Week Picker ---
            _buildTestCard(
              title: "0. เลือกแบบปกติ (Normal)",
              icon: Icons.view_day,
              color: Colors.pink,
              resultText: _dayDate == null
                  ? "ยังไม่ได้เลือก"
                  : _dayDate!.toString(),
              onTap: () async {
                // เรียก SDK โหมด WEEK
                final result = await showDialog<DateTime>(
                  context: context,
                  builder: (context) => CalendarSDK(
                    type: CalendarType.day,
                    initialDate: _dayDate ?? DateTime.now(),
                    firstDate: DateTime(_repository.getMinYear()),
                    lastDate: DateTime.now(),
                  ),
                );

                // รับค่ากลับมาใส่ตัวแปร _weekDate
                if (result != null) {
                  setState(() {
                    _dayDate = result;
                  });
                }
              },
            ),

            // --- ZONE 1: Week Picker ---
            _buildTestCard(
              title: "1. เลือกสัปดาห์ (Week)",
              icon: Icons.view_week,
              color: Colors.teal,
              resultText: _weekDate == null
                  ? "ยังไม่ได้เลือก"
                  : CalendarUtils.formatWeekRange(_weekDate!),
              onTap: () async {
                final result = await showDialog<DateTime>(
                  context: context,
                  builder: (context) => CalendarSDK(
                    type: CalendarType.week,
                    initialDate: _weekDate ?? DateTime.now(),
                    firstDate: DateTime(_repository.getMinYear()),
                    lastDate: DateTime.now(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    _weekDate = result;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            // --- ZONE 2: Month Picker ---
            _buildTestCard(
              title: "2. เลือกเดือน (Month)",
              icon: Icons.calendar_view_month,
              color: Colors.orange,
              resultText: _monthDate == null
                  ? "ยังไม่ได้เลือก"
                  : "${CalendarUtils.thaiMonths[_monthDate!.month - 1]} ${CalendarUtils.toBuddhistYear(_monthDate!.year)}",
              onTap: () async {
                final result = await showDialog<DateTime>(
                  context: context,
                  builder: (context) => CalendarSDK(
                    type: CalendarType.month,
                    initialDate: _monthDate ?? DateTime.now(),
                    firstDate: DateTime(_repository.getMinYear()),
                    lastDate: DateTime.now(),
                  ),
                );

                // รับค่ากลับมาใส่ตัวแปร _monthDate
                if (result != null) {
                  setState(() {
                    _monthDate = result;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            // --- ZONE 3: Year Picker ---
            _buildTestCard(
              title: "3. เลือกปี (Year)",
              icon: Icons.history,
              color: Colors.purple,
              // แสดงผลลัพธ์เป็น ปี พ.ศ.
              resultText: _yearDate == null
                  ? "ยังไม่ได้เลือก"
                  : "ปี พ.ศ. ${CalendarUtils.toBuddhistYear(_yearDate!.year)}",
              onTap: () async {
                // เรียก SDK โหมด YEAR
                final result = await showDialog<DateTime>(
                  context: context,
                  builder: (context) => CalendarSDK(
                    type: CalendarType.year,
                    // ส่งค่าเดิมเข้าไป (ถ้ามี)
                    initialDate: _yearDate ?? DateTime.now(),
                    firstDate: DateTime(_repository.getMinYear()),
                    lastDate: DateTime.now(),
                  ),
                );

                // รับค่ากลับมาใส่ตัวแปร _yearDate
                if (result != null) {
                  setState(() {
                    _yearDate = result;
                  });
                }
              },
            ),

            // --- ZONE 4: Week finder by date ---
            _buildTestCard(
              title: "4. หาช่วงอาทิตย์จากวัน",
              icon: Icons.view_day,
              color: Colors.pink,
              resultText: _weekRange == null
                  ? "ยังไม่ได้เลือกวันที่"
                  : "วันที่เลือก: ${_weekFinderDate!.day}/${_weekFinderDate!.month}\n${CalendarUtils.debugRange(_weekRange!)}",
              onTap: () async {
                final result = await showDialog<DateTime>(
                  context: context,
                  builder: (context) => CalendarSDK(
                    type: CalendarType.day,
                    initialDate: _weekFinderDate ?? DateTime.now(),
                    firstDate: DateTime(_repository.getMinYear()),
                    lastDate: DateTime.now(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    _weekFinderDate = result; // เก็บวันที่เลือกแยกไว้ดู
                    _weekRange = CalendarUtils.getWeekRange(
                      result,
                    ); // หาช่วงสัปดาห์
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Helpers ---

  // ฟังก์ชันสร้าง Card UI (ใช้ร่วมกันแต่รับค่าแยกกัน)
  Widget _buildTestCard({
    required String title,
    required IconData icon,
    required Color color,
    required String resultText,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text(
              "ค่าที่เลือก:",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              resultText,
              style: TextStyle(
                fontSize: 16,
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: color,
                  side: BorderSide(color: color),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("เลือกวันที่"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
