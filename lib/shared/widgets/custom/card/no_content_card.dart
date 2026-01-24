import 'package:dun_diary_app/shared/constant/app_image.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/svg/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class NoContentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final double imageSize;

  const NoContentCard({
    super.key,
    this.title = "",
    this.subtitle = "",
    this.imagePath = AppImage.cuate,
    this.imageSize = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 25, bottom: 20),
      child: Column(
        spacing: 5,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SVGImage(path: imagePath, size: imageSize),
          SizedBox(height: 20),
          CustomText(
            text: title,
            fontSize: Dimension.fontSizes.md,
            fontWeight: Dimension.fontWeights.semiBold,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimension.paddings.md),
            child: CustomText(
              textAlign: TextAlign.center,
              text: subtitle,
              fontSize: Dimension.fontSizes.rg,
              fontWeight: Dimension.fontWeights.regular,
            ),
          ),
        ],
      ),
    );
  }
}