import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_image.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onRecordTap; // เมื่อกดปุ่มบันทึก

  const HomeHeader({
    super.key,
    required this.userName,
    required this.onRecordTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Layer 1: Background
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 340,
          child: Image.asset(
            AppImages.homeBackground,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        // Layer 2: Header, User greeting, Card
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Logo + Notification
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo Area
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.redAccent,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            const CustomText(
                              text: "DUNDIARY",
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        // Bell Icon
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Row 2: Profile Image + Greeting
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Circle
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/heart_mascot.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Fallback
                          child: const Icon(
                            Icons.person,
                            color: CustomColor.accentColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        CustomText(
                          text: "สวัสดี คุณ$userName",
                          fontSize: 18,
                          color: CustomColor.gray900.withOpacity(0.8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 🃏 Layer 3: การ์ด "บันทึกความดัน" (อยู่ใน Flow ของ Column)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomButton(
                  text: AppStrings.home.startRecord,
                  textStyle: TextStyle(
                    color: CustomColor.gray900,
                    fontSize: Dimension.fontSizes.h2,
                    fontWeight: Dimension.fontWeights.regular,
                  ),
                  leadingIcon: SVGImage(
                    path: AppIcons.duotone.pulse,
                    width: 35,
                    height: 35,
                    color: CustomColor.primaryColor,
                  ),
                  trailingIcon: SVGImage(
                    path: AppIcons.duotone.addCircle,
                    width: 28,
                    height: 28,
                    color: CustomColor.primaryColor,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 15,
                  ),
                  boxShadow: [DropShadow.drop_thumb],
                  onPressed: onRecordTap,
                ),
              ),

              // Add some bottom padding if needed
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
