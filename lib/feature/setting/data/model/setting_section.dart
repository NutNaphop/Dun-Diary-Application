import 'package:dun_diary_app/feature/setting/data/model/setting_item.dart';

class SettingSection {
  final String? title;
  final List<SettingItem> items;

  SettingSection({this.title, required this.items});
}
