import 'package:dun_diary_app/feature/setting/data/menu_data.dart';
import 'package:dun_diary_app/feature/setting/data/model/setting_section.dart';
import 'package:flutter/foundation.dart';

class RecoverySettingViewmodel extends ChangeNotifier {
  List<SettingSection> get menuSections => RecoveryMenuData.recoverySettings;
}
