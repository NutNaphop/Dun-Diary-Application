import 'package:dun_diary_app/shared/constant/app_image.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class AnalyzeNoDataView extends StatelessWidget {
  const AnalyzeNoDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 15,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            spacing: 8,
            children: [
              SVGImage(path: AppImage.analyze, width: 105, height: 102),
              CustomText(
                text: "ยังไม่มีข้อมูลในช่วงเวลานี้",
                fontSize: Dimension.fontSizes.h1,
                fontWeight: Dimension.fontWeights.bold,
                color: CustomColor.gray500,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: CustomText(
                  text:
                      "เพิ่มข้อมูลความดันโลหิตก่อน เพื่อให้ AI ช่วยวิเคราะห์ผลและสรุปให้คุณ",
                  fontSize: Dimension.fontSizes.md,
                  fontWeight: Dimension.fontWeights.regular,
                  color: CustomColor.gray400,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
