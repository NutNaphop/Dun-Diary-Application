import 'package:dun_diary_app/shared/constant/app_image.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class NoContentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final double imageWidth;
  final double imageHeight;

  const NoContentCard({
    super.key,
    this.title = "",
    this.subtitle = "",
    this.imagePath = AppImages.emptyFolder,
    this.imageWidth = 80,
    this.imageHeight = 80,
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
          SVGImage(path: imagePath, width: imageWidth, height: imageHeight),
          SizedBox(height: 20),
          CustomText(
            text: title,
            fontSize: Dimension.fontSizes.h2,
            fontWeight: Dimension.fontWeights.semiBold,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimension.paddings.md),
            child: CustomText(
              textAlign: TextAlign.center,
              text: subtitle,
              fontSize: Dimension.fontSizes.md,
              fontWeight: Dimension.fontWeights.regular,
            ),
          ),
        ],
      ),
    );
  }
}
