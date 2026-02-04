import 'package:dun_diary_app/feature/stat/presentation/widgets/stat_card/components/stat_icon.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class AnalyzeSuccessView extends StatelessWidget {
  const AnalyzeSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Row(
          spacing: 10,
          children: [
            StatIcon(
              width: 31,
              height: 31,
              backgroundColor: CustomColor.blue6,
              icon: SVGImage(
                path: AppIcons.fill.sparkle,
                color: CustomColor.blue7,
                width: 21,
                height: 21,
              ),
            ),
            CustomText(
              text: "ผลวิเคราะห์จาก AI",
              fontSize: Dimension.fontSizes.h2,
              fontWeight: Dimension.fontWeights.semiBold,
            ),
          ],
        ),
        CustomText(
          text:
              "เยี่ยมมาก! ในรอบ 7 วันที่ผ่านมา ค่าความดันของคุณมี ความคงที่ โดยไม่มีการแกว่งตัวที่น่ากังวลสภาพร่างกาย สมดุลและพร้อมสำหรับการทำกิจกรรมต่างๆ",
          fontSize: Dimension.fontSizes.md,
          fontWeight: Dimension.fontWeights.regular,
        ),

        SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(15),
              border: BoxBorder.all(width: 1, color: CustomColor.blue1),
              color: CustomColor.blue8,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "คำแนะนำ",
                  fontSize: Dimension.fontSizes.h2,
                  fontWeight: Dimension.fontWeights.semiBold,
                ),
                SizedBox(height: 5),
                // need to render a data
                for (int i = 0; i < 2; i++)
                  CustomText(
                    text: "•  รักษาพฤติกรรมการกิน",
                    fontSize: Dimension.fontSizes.md,
                    fontWeight: Dimension.fontWeights.regular,
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 76),
          child: CustomButton(
            text: "วิเคราะห์ผลอีกครั้ง",
            leadingIcon: SVGImage(
              path: AppIcons.outline.arrowClockwise,
              width: 20,
              height: 20,
              color: CustomColor.accentColor,
            ),
            type: CustomButtonType.outline,
            width: double.infinity,
            textStyle: TextStyle(
              color: CustomColor.accentColor,
              fontSize: Dimension.fontSizes.md,
              fontWeight: Dimension.fontWeights.bold,
            ),
            borderColor: CustomColor.accentColor,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
