import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/ui/wheel_number/wheel_number.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class BpCardLayout extends StatelessWidget {
  final int sys;
  final int dia;
  final int pul;
  final ValueChanged<int> onSysChanged;
  final ValueChanged<int> onDiaChanged;
  final ValueChanged<int> onPulChanged;

  const BpCardLayout({
    super.key,
    required this.sys,
    required this.dia,
    required this.pul,
    required this.onSysChanged,
    required this.onDiaChanged,
    required this.onPulChanged,
  });

  @override
  Widget build(BuildContext context) {
    const double itemHeight = 50.0;
    const double wheelWidth = 70.0;

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildBpColumn("SYS", sys, onSysChanged, wheelWidth, itemHeight)),
              Expanded(child: _buildBpColumn("DIA", dia, onDiaChanged, wheelWidth, itemHeight)),
              Expanded(child: _buildBpColumn("PUL", pul, onPulChanged, wheelWidth, itemHeight)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBpColumn(String title, int value, ValueChanged<int> onChanged, double width, double height) {
    return Column(
      spacing: 20,
      children: [
        CustomText(
          text: title,
          fontSize: Dimension.fontSizeHeading2,
          fontWeight: Dimension.fontWeightSemiBold,
        ),
        SizedBox(
          width: width,
          height: height * 3,
          child: WheelNumber(
            initialValue: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
