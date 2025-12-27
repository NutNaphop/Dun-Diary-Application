import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget content;
  final EdgeInsets? contentPadding;

  const CustomCard({
    super.key,
    this.title,
    this.description,
    required this.content,
    this.contentPadding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: contentPadding,
        width: double.infinity,
        decoration: BoxDecoration(
          color: CustomColor.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [DropShadow.drop_popup],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              children: [
                if (title != null)
                  CustomText(
                    text: title!,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                if (description != null)
                  CustomText(
                    text: description!,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
              ],
            ),
            Container(child: content),
          ],
        ),
      ),
    );
  }
}
