import 'package:dun_diary_app/shared/color/color.dart';
import 'package:dun_diary_app/shared/utils/dimension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomText({
    Key? key,
    required this.text,
    this.textAlign,
    this.color = CustomColor.gray900,
    this.fontSize = Dimension.fontSizeRegular,
    this.fontWeight = Dimension.fontWeightRegular,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.anuphan(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
    );
  }
}

class HeadingText extends StatelessWidget {
  final String text;

  const HeadingText({
    Key? key,
    required this.text,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CustomText(
        text: text,
        fontSize: Dimension.fontSizeHeading1,
        fontWeight: Dimension.fontWeightBold,       
      );
  }
}

class SubHeadingText extends StatelessWidget {
  final String text;

  const SubHeadingText({
    Key? key,
    required this.text,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CustomText(
        text: text,
        fontSize: Dimension.fontSizeHeading2,
        fontWeight: Dimension.fontWeightSemiBold,       
      );
  }
}