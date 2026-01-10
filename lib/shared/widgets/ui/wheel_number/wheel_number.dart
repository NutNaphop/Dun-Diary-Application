import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class WheelNumber extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const WheelNumber({
    super.key,
    this.initialValue = 0,
    required this.onChanged,
    this.min = 50,
    this.max = 200,
  });

  @override
  State<WheelNumber> createState() => _WheelNumberState();
}

class _WheelNumberState extends State<WheelNumber> {
  late FixedExtentScrollController _controller;
  late int _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    // คำนวณ index เริ่มต้นโดยลบด้วยค่า min (เช่น ค่า 120 -> index 70)
    int initialIndex = widget.initialValue - widget.min;
    if (initialIndex < 0) initialIndex = 0;
    _controller = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  void didUpdateWidget(covariant WheelNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      // เช็คว่าค่าที่เปลี่ยนมา ไม่ใช่ค่าปัจจุบันที่กำลังเลือกอยู่ (ป้องกันการ animate ซ้ำตอนเลื่อนเอง)
      if (widget.initialValue != _selectedValue) {
        _selectedValue = widget.initialValue;
        int targetIndex = widget.initialValue - widget.min;
        if (targetIndex < 0) targetIndex = 0;
        _controller.animateToItem(
          targetIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int totalCount = widget.max - widget.min + 1;
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemExtent = constraints.maxHeight / 3;
        return Stack(
          children: [
            ListWheelScrollView.useDelegate(
              controller: _controller,
              physics: const FixedExtentScrollPhysics(parent: BouncingScrollPhysics()),
              itemExtent: itemExtent,
              perspective: 0.001,
              diameterRatio: 100,
              onSelectedItemChanged: (index) {
                final value = index + widget.min;
                setState(() {
                  _selectedValue = value;
                });
                widget.onChanged(value);
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: totalCount,
                builder: (context, index) {
                  final value = index + widget.min;
                  return Container(
                    alignment: Alignment.center,
                    child: CustomText(
                      text: '$value',
                      fontSize: Dimension.fontSizes.h1,
                      fontWeight: Dimension.fontWeights.bold,
                      color: value == _selectedValue
                          ? CustomColor.gray900
                          : CustomColor.gray400,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: itemExtent,
              left: 0,
              right: 0,
              child: Container(height: 1, color: CustomColor.gray300),
            ),
            Positioned(
              bottom: itemExtent,
              left: 0,
              right: 0,
              child: Container(height: 1, color: CustomColor.gray300),
            ),
          ],
        );
      },
    );
  }
}
