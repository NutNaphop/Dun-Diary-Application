import 'package:flutter/material.dart';

class CalendarFooter extends StatelessWidget {
  final VoidCallback onSelect;
  final VoidCallback onGoToToday;
  final String todayButtonText;

  const CalendarFooter({
    super.key,
    required this.onSelect,
    required this.onGoToToday,
    required this.todayButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onSelect,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFF009688,
                ), // สี Teal ตามภาพ
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: const Text(
                'เลือก',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: onGoToToday,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Text(
              todayButtonText,
              style: const TextStyle(
                color: Color(0xFF009688), // สีเดียวกับธีม (Teal)
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}