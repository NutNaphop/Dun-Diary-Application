import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/feature/setting/data/model/setting_section.dart';
import 'package:dun_diary_app/feature/setting/presentation/profileSettingScreen/profile_setting_viewModel.dart';
import 'package:dun_diary_app/feature/setting/presentation/widgets/section/setting_menu_section.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_image.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => ProfileSettingViewmodel(),
      child: const ProfileSettingScreen(),
    );
  }

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ProfileSettingViewmodel>();

    return CustomScaffold(
      usePadding: false,
      appBar: MainAppBar(
        title: 'ข้อมูลของฉัน',
        showBack: true,
        backIconPath: AppIcons.outline.leftArrow,
        onBackPressed: NavigationService.instance.goBack,
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 25),
        child: Column(
          spacing: 14,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(AppImages.profile.avatar1),
            ),
            CustomText(
              text: "ราชาปีศาจ",
              fontSize: Dimension.fontSizes.h1,
              fontWeight: Dimension.fontWeights.bold,
            ),
            SettingMenuSection(
              section: SettingSection(
                items: viewModel.menuSections.first.items,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
