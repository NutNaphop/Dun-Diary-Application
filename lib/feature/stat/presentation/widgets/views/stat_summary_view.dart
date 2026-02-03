import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/ui/card/blood_pressure_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/bp_graph_sdk.dart';
import 'package:flutter/material.dart';

class StatSummaryView extends StatelessWidget {
  final List<dynamic> data; // รับข้อมูลที่จะแสดงในกราฟ

  const StatSummaryView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 350,
          width: double.infinity,
          padding: const EdgeInsets.only(top: 20, right: 10),
          child: BpGraphSdk(data: List.empty()),
        ),
        SizedBox(height: 30),
        CustomText(
          text: "สรุปข้อมูลสุขภาพ",
          fontSize: Dimension.fontSizes.h1,
          fontWeight: Dimension.fontWeights.bold,
        ),
        SizedBox(height: 15),
        BloodPressureCard(
          bloodPressureLevel: 1,
          date: "3 ธ.ค. - 19 ธ.ค. 2565",
          leadingIcon: Icon(Icons.abc, size: 90),
        ),
      ],
    );
  }
}
