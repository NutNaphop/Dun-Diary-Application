import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_image.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final VoidCallback onTap;
  const ProfileCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      contentPadding: EdgeInsets.zero,
      content: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(AppImages.profile.avatar1),
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    CustomText(
                      text: "คุณราชาปีศาจ",
                      fontSize: Dimension.fontSizes.h2,
                      fontWeight: Dimension.fontWeights.semiBold,
                    ),
                  ],
                ),
                Spacer(),
                SVGImage(
                  path: AppIcons.outline.rightArrow,
                  width: 22,
                  height: 22,
                  color: CustomColor.gray900,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
