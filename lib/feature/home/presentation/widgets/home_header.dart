import 'package:dun_diary_app/feature/home/presentation/home_viewModel.dart';
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
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  final String userName;

  const HomeHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<HomeViewmodel>(); // เอาไว้กดปุ่ม

    // Responsive height: Takes 35% of screen height, but at least 340px to fit content
    final double screenHeight = MediaQuery.of(context).size.height;
    final double headerHeight = (screenHeight * 0.35).clamp(
      340.0,
      double.infinity,
    );

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Layer 1: Background
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Image.asset(
            AppImages.homeBackground,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        // Layer 1.5: Invisible spacer to force minimum height
        SizedBox(height: headerHeight, width: double.infinity),

        // Layer 2: Header, User greeting, Card
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
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
                            Image.asset(
                              AppConfigImages.logoWithText,
                              width: 144,
                              height: 39,
                            ),
                          ],
                        ),
                        // Bell Icon
                        GestureDetector(
                          onTap: () {
                            viewModel.seedData();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: CustomColor.white,
                              shape: BoxShape.circle,
                            ),
                            child: SVGImage(
                              path: AppIcons.outline.bell,
                              width: 24,
                              height: 24,
                              color: CustomColor.accentColor,
                            ),
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
                          decoration: BoxDecoration(
                            boxShadow: [DropShadow.drop_card],
                          ),
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                              AppImages.profile.avatar1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        CustomText(
                          text: AppStrings.home.greeting(userName),
                          fontSize: Dimension.fontSizes.h2,
                          fontWeight: Dimension.fontWeights.medium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              // 🃏 Layer 3: การ์ด "บันทึกความดัน" (อยู่ใน Flow ของ Column)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomButton(
                  text: AppStrings.home.recordPressure,
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
                  onPressed: viewModel.redirectToRecord,
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
