import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/calendar_sdk.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/models/calendar_types.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/utils/calendar_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
              // แสดงผลลัพธ์เป็นช่วงวันที่
              resultText: _weekDate == null
                  ? "ยังไม่ได้เลือก"
                  : _formatWeekRange(_weekDate!),
              onTap: () async {
                // เรียก SDK โหมด WEEK
                final result = await showDialog<DateTime>(
                  context: context,
                  builder: (context) => CalendarSDK(
                    type: CalendarType.week,
                    // ส่งค่าเดิมเข้าไป (ถ้ามี) หรือส่งค่าปัจจุบัน
                    initialDate: _weekDate ?? DateTime.now(),
                  ),
                );

                // รับค่ากลับมาใส่ตัวแปร _weekDate
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
              // แสดงผลลัพธ์เป็น เดือน ปี
              resultText: _monthDate == null
                  ? "ยังไม่ได้เลือก"
                  : "${CalendarUtils.thaiMonths[_monthDate!.month - 1]} ${CalendarUtils.toBuddhistYear(_monthDate!.year)}",
              onTap: () async {
                // เรียก SDK โหมด MONTH
                final result = await showDialog<DateTime>(
                  context: context,
                  builder: (context) => CalendarSDK(
                    type: CalendarType.month,
                    // ส่งค่าเดิมเข้าไป (ถ้ามี)
                    initialDate: _monthDate ?? DateTime.now(),
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

  // Helper แปลงวันที่เป็นช่วงสัปดาห์ (เช่น 19 - 25 มกราคม 2569)
  String _formatWeekRange(DateTime date) {
    // หาวันจันทร์
    final start = date.subtract(Duration(days: date.weekday - 1));
    // หาวันอาทิตย์
    final end = start.add(const Duration(days: 6));

    final df = DateFormat('d', 'th'); // วันที่
    final mf = DateFormat('MMMM', 'th'); // เดือนเต็ม
    final y = CalendarUtils.toBuddhistYear(date.year);

    // กรณีข้ามเดือน (เช่น 29 ม.ค. - 4 ก.พ.)
    if (start.month != end.month) {
      final mfStart = DateFormat('MMM', 'th'); // เดือนย่อ
      final mfEnd = DateFormat('MMM', 'th');
      return "${df.format(start)} ${mfStart.format(start)} - ${df.format(end)} ${mfEnd.format(end)} $y";
    }

    // กรณีเดือนเดียวกัน
    return "${df.format(start)} - ${df.format(end)} ${mf.format(end)} $y";
  }
}
