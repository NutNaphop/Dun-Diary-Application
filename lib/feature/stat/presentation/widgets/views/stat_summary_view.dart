import 'package:dun_diary_app/feature/stat/presentation/widgets/ui/card/blood_pressure_card.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/ui/card/stat_card.dart';
import 'package:dun_diary_app/shared/constant/app_animations.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_lottie_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/bp_graph_sdk.dart';
import 'package:flutter/material.dart';

class StatSummaryView extends StatelessWidget {
  final List<dynamic> data; // รับข้อมูลที่จะแสดงในกราฟ

  const StatSummaryView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          // Graph Section
          CustomCard(
            contentPadding: const EdgeInsets.all(20),
            content: Container(
              height: 350,
              width: double.infinity,
              child: BpGraphSdk(data: List.empty()),
            ),
          ),
          const SizedBox(height: 30),

          // Summary Section
          CustomText(
            text: "สรุปข้อมูลสุขภาพ",
            fontSize: Dimension.fontSizes.h1,
            fontWeight: Dimension.fontWeights.bold,
          ),
          const SizedBox(height: 15),
          BloodPressureCard(
            bloodPressureLevel: 1,
            date: "3 ธ.ค. - 19 ธ.ค. 2565",
            leadingIcon: LottieAnimation(
              path: AppAnimations.blushing,
              width: 90,
              height: 90,
            ),
          ),
          const SizedBox(height: 20),

          // Stat Section
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4, // กำหนดจำนวน Item ที่ต้องการแสดง
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 120,
            ),
            itemBuilder: (context, index) {
              return const StatCard(
                leadingIcon: Icon(Icons.abc, size: 25),
                title: "ค่าเฉลี่ยความดัน",
                value: "82/52",
                description: "อยู่ในช่วงปกติ",
              );
            },
          ),

          // Analyze Seciton
          SizedBox(height: 15),
          Text("Analyze Section"),
        ],
      ),
    );
  }
}
