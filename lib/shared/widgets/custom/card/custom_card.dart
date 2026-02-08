import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final String? description;
  final double titleFontSize;
  final double descriptionFontSize;
  final TextAlign titleTextAlign;
  final TextAlign descriptionTextAlign;
  final Widget content;
  final EdgeInsets? contentPadding;

  const CustomCard({
    super.key,
    this.title,
    this.description,
    this.titleFontSize = 18,
    this.descriptionFontSize = 18,
    this.titleTextAlign = TextAlign.start,
    this.descriptionTextAlign = TextAlign.start,
    required this.content,
    this.contentPadding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: contentPadding,
      width: double.infinity,
      decoration: BoxDecoration(
        color: CustomColor.white,
        borderRadius: BorderRadius.circular(10),
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
                    fontWeight: FontWeight.bold,
                    textAlign: titleTextAlign,
                  ),
                if (description != null)
                  CustomText(
                    text: description!,
                    fontSize: descriptionFontSize,
                    fontWeight: FontWeight.bold,
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
