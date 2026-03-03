import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final String? description;
  final double titleFontSize;
  final double descriptionFontSize;
  final FontWeight titleFontWeight;
  final FontWeight descriptionFontWeight;
  final Color? titleColor;
  final Color? descriptionColor;
  final TextAlign titleTextAlign;
  final TextAlign descriptionTextAlign;
  final Widget content;
  final EdgeInsets? contentPadding;
  final double borderRadius;

  CustomCard({
    super.key,
    this.title,
    this.description,
    this.titleFontSize = 18,
    this.descriptionFontSize = 18,
    this.titleFontWeight = FontWeight.w500,
    this.descriptionFontWeight = FontWeight.bold,
    this.titleColor,
    this.descriptionColor,
    this.titleTextAlign = TextAlign.start,
    this.descriptionTextAlign = TextAlign.start,
    required this.content,
    this.contentPadding = const EdgeInsets.all(0),
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: contentPadding,
      width: double.infinity,
      decoration: BoxDecoration(
        color: CustomColor.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [DropShadow.drop_card],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (title != null || description != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null)
                  CustomText(
                    text: title!,
                    fontSize: titleFontSize,
                    fontWeight: titleFontWeight,
                    color: titleColor,
                    textAlign: titleTextAlign,
                  ),
                if (description != null)
                  CustomText(
                    text: description!,
                    fontSize: descriptionFontSize,
                    fontWeight: descriptionFontWeight,
                    color: descriptionColor,
                    textAlign: descriptionTextAlign,
                  ),
              ],
            ),
          Container(child: content),
        ],
      ),
    );
  }
}
