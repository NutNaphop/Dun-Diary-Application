import 'package:dun_diary_app/shared/constant/app_animations.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_lottie_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class AnalyzeProcessView extends StatelessWidget {
  const AnalyzeProcessView({super.key});

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
              LottieAnimation(
                path: AppAnimations.aiChatting,
                width: 101,
                height: 122,
              ),
              CustomText(
                text: "กำลังประมวลผลสุขภาพ",
                fontSize: Dimension.fontSizes.h1,
                fontWeight: Dimension.fontWeights.bold,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: CustomText(
                  text: "AI กำลังวิเคราะห์ผลเพื่อคุณโดยเฉพาะ",
                  fontSize: Dimension.fontSizes.md,
                  fontWeight: Dimension.fontWeights.regular,
                  color: CustomColor.gray600,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 15),
              CustomText(
                text: "กรุณารอสักครู่ อย่าปิดหรือออกจากหน้าจอนี้",
                fontSize: Dimension.fontSizes.md,
                fontWeight: Dimension.fontWeights.bold,
                color: CustomColor.gray600,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
