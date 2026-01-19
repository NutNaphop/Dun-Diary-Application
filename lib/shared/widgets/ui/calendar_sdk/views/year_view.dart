import 'package:flutter/material.dart';
import '../utils/calendar_utils.dart';

class YearPickerView extends StatelessWidget {
  final int selectedYear; // ปี ค.ศ. ที่เลือกอยู่ปัจจุบัน
  final Function(int) onYearSelected; // ส่งปี ค.ศ. กลับไป

  const YearPickerView({
    super.key,
    required this.selectedYear,
    required this.onYearSelected,
  });

  @override
  Widget build(BuildContext context) {
    // กำหนดช่วงปีที่จะแสดง (เช่น ย้อนหลัง 100 ปี จากปีปัจจุบัน)
    final currentYear = DateTime.now().year;
    final startYear = currentYear - 5;
    final totalYears =  5; 

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 คอลัมน์ตามรูป
        childAspectRatio: 2.0, // สัดส่วนกว้าง x สูง ของปุ่ม
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: totalYears,
      itemBuilder: (context, index) {
        // คำนวณปีของปุ่มนี้ (เรียงจากปีปัจจุบันถอยหลัง หรือเรียงจากอดีตขึ้นมาก็ได้)
        // ในที่นี้ขอเรียงจากปัจจุบันถอยหลังให้หาง่ายๆ หรือจะเรียงปกติก็ได้
        // เอาแบบเรียงปกติ: startYear + index
        final int year = startYear + index;

        // เช็คสถานะ
        final isSelected = year == selectedYear;
        final isFuture = year > currentYear; // กฎเหล็ก: ห้ามเลือกปีอนาคต

        return _buildYearButton(year, isSelected, isFuture);
      },
    );
  }

  Widget _buildYearButton(int year, bool isSelected, bool isFuture) {
    // แปลงเป็น พ.ศ. เพื่อแสดงผล
    final buddhistYear = CalendarUtils.toBuddhistYear(year);

    return InkWell(
      onTap: isFuture
          ? null // ถ้าเป็นอนาคต กดไม่ได้
          : () => onYearSelected(year),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.teal
              : Colors.transparent, // สีเขียวถ้าเลือกอยู่
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : isFuture
              ? null
              : Border.all(
                  color: Colors.grey.shade200,
                ), // กรอบจางๆ สำหรับปีปกติ
        ),
        alignment: Alignment.center,
        child: Text(
          '$buddhistYear',
          style: TextStyle(
            fontSize: 18,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Colors
                      .white // ตัวหนังสือขาวถ้าเลือก
                : isFuture
                ? Colors
                      .grey
                      .shade300 // สีเทาจางถ้ากดไม่ได้
                : Colors.black87,
          ),
        ),
      ),
    );
  }
}
