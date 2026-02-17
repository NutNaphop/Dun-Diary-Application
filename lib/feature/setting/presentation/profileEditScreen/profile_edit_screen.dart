import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/feature/setting/presentation/profileSettingScreen/profile_setting_viewModel.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => ProfileSettingViewmodel(),
      child: ProfileEditScreen(),
    );
  }

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      usePadding: false,
      appBar: MainAppBar(
        title: "แก้ไขโปรไฟล์",
        showBack: true,
        backIconPath: AppIcons.outline.leftArrow,
        onBackPressed: NavigationService.instance.goBack,
      ),
      body: Column(children: [Text("Edit Screen")]),
    );
  }
}
