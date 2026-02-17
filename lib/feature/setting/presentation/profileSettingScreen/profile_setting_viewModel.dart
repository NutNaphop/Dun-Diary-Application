import 'package:dun_diary_app/feature/setting/data/menu_data.dart';
import 'package:dun_diary_app/feature/setting/data/model/setting_section.dart';
import 'package:flutter/material.dart';

class ProfileSettingViewmodel extends ChangeNotifier {
  List<SettingSection> get menuSections => SettingMenuData.profileSettings;
}
