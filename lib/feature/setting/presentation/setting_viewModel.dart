import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/feature/setting/data/menu_data.dart';
import 'package:dun_diary_app/feature/setting/data/model/setting_section.dart';
import 'package:flutter/material.dart';

class SettingViewmodel extends ChangeNotifier {
  List<SettingSection> get menuSections => SettingMenuData.mainSettings;

  void redirectToProfile() async {
    await NavigationService.instance.pushNamed(AppRoutes.setting.profile);
    notifyListeners();
  }
}
