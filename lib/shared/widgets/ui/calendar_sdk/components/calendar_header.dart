import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';
import '../utils/calendar_utils.dart';

enum CalendarHeaderStyle { week, month, year }

class CalendarHeader extends StatelessWidget {
  final DateTime currentDate;
  final CalendarHeaderStyle style;
  final VoidCallback? onMonthTap;
  final VoidCallback? onYearTap;

  const CalendarHeader({
    super.key,
    required this.currentDate,
    required this.style,
    this.onMonthTap,
    this.onYearTap,
  });

  @override
  Widget build(BuildContext context) {
    // เตรียมข้อมูล
    final monthName = CalendarUtils.thaiMonths[currentDate.month - 1];
    final yearBuddhist = CalendarUtils.toBuddhistYear(currentDate.year);

    return Padding(
      padding: EdgeInsetsGeometry.zero,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. ส่วนเนื้อหา Header (Dropdowns หรือ Title)
          Row(
            children: [
              // --- Case: Week View (โชว์ เดือน + ปี) ---
              if (style == CalendarHeaderStyle.week) ...[
                _buildDropdownButton(text: monthName, onTap: onMonthTap),
                const SizedBox(width: 12),
                _buildDropdownButton(text: '$yearBuddhist', onTap: onYearTap),
              ],

              // --- Case: Month View (โชว์ ปี อย่างเดียว) ---
              if (style == CalendarHeaderStyle.month) ...[
                _buildDropdownButton(text: '$yearBuddhist', onTap: onYearTap),
              ],
            ],
          ),

          // --- Case: Year View (โชว์ Title "เลือกปี" ตรงกลาง) ---
          if (style == CalendarHeaderStyle.year)
            const Text(
              "เลือกปี",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

          // 2. ปุ่มปิด (Close Button) - อยู่ขวาสุดเสมอ
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              constraints:
                  const BoxConstraints(), // ลบ padding พื้นฐานออกให้ชิดขวา
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownButton({required String text, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: CustomColor.gray300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: text,
              fontSize: Dimension.fontSizes.md,
              fontWeight: Dimension.fontWeights.regular,
              color: CustomColor.gray900,
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 20, color: CustomColor.gray900),
          ],
        ),
      ),
    );
  }
}
