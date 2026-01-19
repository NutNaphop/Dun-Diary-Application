import 'package:flutter/material.dart';
import '../utils/calendar_utils.dart';

class MonthPickerView extends StatelessWidget {
  final int selectedMonth; // เดือนที่เลือกอยู่ (1-12)
  final int viewingYear;   // ปีที่กำลังดูอยู่ (สำคัญมาก เอาไว้เช็คว่าอนาคตไหม)
  final Function(int) onMonthSelected; // ส่งค่าเดือนที่เลือกกลับไป

  const MonthPickerView({
    super.key,
    required this.selectedMonth,
    required this.viewingYear,
    required this.onMonthSelected,
  });

  @override
  Widget build(BuildContext context) {
    // ดึงวันเวลาปัจจุบันเพื่อใช้เทียบเงื่อนไข
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 คอลัมน์
        childAspectRatio: 1.5, // สัดส่วนปุ่ม (กว้างกว่าสูงนิดหน่อย)
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: 12, // มีแค่ 12 เดือน
      itemBuilder: (context, index) {
        final monthIndex = index + 1; // แปลง index 0-11 เป็นเดือน 1-12
        
        // เช็คเงื่อนไข: เป็นเดือนในอนาคตหรือไม่?
        // Logic: ถ้าปีที่ดูอยู่ > ปีปัจจุบัน (เป็นไปไม่ได้เพราะดักที่ YearView แล้ว)
        //       หรือ (ถ้าปีเท่ากัน และ เดือนมากกว่าเดือนปัจจุบัน) -> ห้ามกด
        bool isFuture = false;
        if (viewingYear > currentYear) {
          isFuture = true;
        } else if (viewingYear == currentYear && monthIndex > currentMonth) {
          isFuture = true;
        }

        final isSelected = monthIndex == selectedMonth;

        return _buildMonthButton(monthIndex, isSelected, isFuture);
      },
    );
  }

  Widget _buildMonthButton(int monthIndex, bool isSelected, bool isFuture) {
    // ดึงชื่อเดือนไทยจาก Utils
    final monthName = CalendarUtils.thaiMonths[monthIndex - 1];

    return InkWell(
      onTap: isFuture 
          ? null 
          : () => onMonthSelected(monthIndex),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected || isFuture
              ? null
              : Border.all(color: Colors.grey.shade300), // กรอบจางๆ
        ),
        alignment: Alignment.center,
        child: Text(
          monthName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected 
                ? Colors.white 
                : isFuture 
                    ? Colors.grey.shade300 
                    : Colors.black87,
          ),
        ),
      ),
    );
  }
}