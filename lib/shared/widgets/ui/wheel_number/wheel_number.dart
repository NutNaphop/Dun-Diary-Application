import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class WheelNumber extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;
  final int totalCount;

  const WheelNumber({
    super.key,
    this.initialValue = 0,
    required this.onChanged,
    this.totalCount = 300,
  });

  @override
  State<WheelNumber> createState() => _WheelNumberState();
}

class _WheelNumberState extends State<WheelNumber> {
  late FixedExtentScrollController _controller;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialValue;
    _controller = FixedExtentScrollController(initialItem: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant WheelNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      // เช็คว่าค่าที่เปลี่ยนมา ไม่ใช่ค่าปัจจุบันที่กำลังเลือกอยู่ (ป้องกันการ animate ซ้ำตอนเลื่อนเอง)
      if (widget.initialValue != _selectedIndex) {
        _selectedIndex = widget.initialValue;
        _controller.animateToItem(
          widget.initialValue,
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
                setState(() {
                  _selectedIndex = index;
                });
                widget.onChanged(index);
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: widget.totalCount,
                builder: (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    child: CustomText(
                      text: '$index',
                      fontSize: Dimension.fontSizeHeading1,
                      fontWeight: Dimension.fontWeightBold,
                      color: index == _selectedIndex
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
