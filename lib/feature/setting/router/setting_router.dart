import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/router/base_feature_router.dart';
import 'package:dun_diary_app/feature/setting/presentation/profileEditScreen/profile_edit_screen.dart';
import 'package:dun_diary_app/feature/setting/presentation/profileSettingScreen/profile_setting_screen.dart';
import 'package:flutter/material.dart';

class SettingRouter extends BaseFeatureRouter {
  @override
  Map<String, Widget Function(dynamic args)> get routes => {
    AppRoutes.setting.profile: (_) => ProfileSettingScreen.create(),
    AppRoutes.setting.profileEdit: (_) => ProfileEditScreen.create(),
    AppRoutes.setting.recovery: (_) => const Scaffold(
      body: Center(child: Text("Recovery Screen (Coming Soon)")),
    ),
    AppRoutes.setting.tutorial: (_) => const Scaffold(
      body: Center(child: Text("Tutorial Screen (Coming Soon)")),
    ),
  };
}
