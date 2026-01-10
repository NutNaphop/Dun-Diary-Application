import 'dart:math';

import 'package:dun_diary_app/data/blood_pressure/model/record_model.dart';
import 'package:flutter/material.dart';

class DemoRecord extends StatelessWidget {
  final int? currentAvgLevel;
  final ValueChanged<BloodPressure> onBPValset;
  final ValueChanged<int?> onAVGValset;

  const DemoRecord({
    super.key,
    this.currentAvgLevel,
    required this.onBPValset,
    required this.onAVGValset,
  });

  @override
  Widget build(BuildContext context) {

    var random = Random();
    var sys = random.nextInt(200);
    var dia = random.nextInt(200);
    var pul = random.nextInt(200);
    var bp = BloodPressure(sys: sys, dia: dia, pul: pul);

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Logic: กำหนดค่าความดันตัวอย่าง
              onBPValset(bp);
            },
            child: Text("Set Value"),
          ),
          ElevatedButton(
            onPressed: () {
              int? nextLevel;
              if (currentAvgLevel == null) {
                nextLevel = 0;
              } else if (currentAvgLevel! >= 4) {
                nextLevel = null;
              } else {
                nextLevel = currentAvgLevel! + 1;
              }
              onAVGValset(nextLevel);
            },
            child: Text("Set Average"),
          ),
        ],
      ),
    );
  }
}
