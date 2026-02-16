import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:flutter/material.dart';

// Main Custom Text
class CustomText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextOverflow? overflow;
  final int? maxLines;

  const CustomText({
    Key? key,
    required this.text,
    this.textAlign,
    this.color,
    this.fontSize = 12.0,
    this.fontWeight = FontWeight.normal,
    this.overflow,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;

    return Text(
      text,
      style: TextStyle(
        color: color ?? defaultStyle.color ?? CustomColor.gray900,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: "NotoSanThai",
      ),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}

// Use Custom Text as Heading
class HeadingText extends StatelessWidget {
  final String text;

  const HeadingText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      fontSize: Dimension.fontSizes.h1,
      fontWeight: Dimension.fontWeights.bold,
    );
  }
}

// Use Custom Text as Heading
class SubHeadingText extends StatelessWidget {
  final String text;

  const SubHeadingText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      fontSize: Dimension.fontSizes.h2,
      fontWeight: Dimension.fontWeights.semiBold,
    );
  }
}
