import 'package:dun_diary_app/data/analyze_record/model/analyze_result_model.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/analyze_card/analyze_card.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/card/blood_pressure_card.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/stat_card/components/stat_icon.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/stat_card/stat_card.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_lottie_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/bp_graph_sdk.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/models/blood_pressure_graph_models.dart';
import 'package:flutter/material.dart';

class StatSummaryView extends StatelessWidget {
  final AnalyzeState analyzeState;
  final AnalyzeResultModel? resultFromAi;
  final List<StatCardData> data; // รับข้อมูลที่จะแสดงในกราฟ
  final List<BloodPressureGraphData> graphData;
  final VoidCallback? onSeed;
  final VoidCallback? onAnalyzePressed;

  const StatSummaryView({
    super.key,
    required this.analyzeState,
    required this.resultFromAi,
    required this.data,
    required this.graphData,
    this.onSeed,
    required this.onAnalyzePressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 39),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomButton(text: "Generate Data", onPressed: onSeed),
            SizedBox(height: 15),

            // Graph Section
            CustomCard(
              contentPadding: const EdgeInsets.all(20),
              content: Container(
                height: 350,
                width: double.infinity,
                child: BpGraphSdk(data: graphData),
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
                path: BloodPressureUtils.mapLevelAnimation(1),
                width: 90,
                height: 90,
              ),
            ),
            const SizedBox(height: 20),

            // Stat Section
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length, // กำหนดจำนวน Item ที่ต้องการแสดง
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 120,
              ),
              itemBuilder: (context, index) {
                final item = data[index];
                return StatCard(
                  leadingIcon: StatIcon(
                    width: 25,
                    height: 25,
                    backgroundColor: item.background,
                    icon: SVGImage(
                      path: item.iconPath,
                      width: 15,
                      height: 15,
                      color: item.foreground,
                    ),
                  ),
                  title: item.title,
                  value: item.value,
                  description: item.description,
                );
              },
            ),

            // Analyze Seciton
            SizedBox(height: 15),
            AnalyzeCard(
              state: analyzeState,
              resultFromAi: resultFromAi,
              isInternetConnect: true,
              onPressed: onAnalyzePressed,
            ),
          ],
        ),
      ),
    );
  }
}
