import 'package:dun_diary_app/shared/constant/app_image.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/card/card_item.dart';
import 'package:dun_diary_app/shared/widgets/svg/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';

class NoFoundCard extends StatelessWidget {
  
  final String title; 
  final String subtitle;

  const NoFoundCard({
    super.key,
    this.title = "",
    this.subtitle = ""
    });
    
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 25, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SVGImage(path: AppImage.cuate, size: 80,),
          SizedBox(height: 20),
          CustomText(text: title, fontSize: Dimension.fontSizeMedium,fontWeight: Dimension.fontWeightSemiBold), 
          CustomText(text: subtitle, fontSize: Dimension.fontSizeSmall, fontWeight: Dimension.fontWeightRegular,),
        ]),
    );
  }
}

class ContentCard extends StatelessWidget {
  final Widget leading;
  final String label;
  final String description;
  final String value;

    const ContentCard({
      super.key,
      required this.leading,
      required this.label,
      required this.description,
      required this.value
      });

  @override
  Widget build(BuildContext context) {
    return CardItem(
        leading: leading,
        title: label,
        subtitle: description,
        trailing: CustomText(
          text: value,
          fontSize: Dimension.fontSizeHeading1,
          fontWeight: Dimension.fontWeightSemiBold,
        ),
        hasDivider: label != 'PUL',
      );
  }

}
