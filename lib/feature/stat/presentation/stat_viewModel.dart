import 'package:dun_diary_app/feature/stat/presentation/widgets/stat_card/stat_card.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:flutter/material.dart';

class StatViewmodel extends ChangeNotifier {
  final List<StatCardData> _data = [
    StatCardData(
      iconPath: AppIcons.duotone.heartPulse,
      title: "ค่าเฉลี่ยความดัน",
      value: "82/52",
      description: "อยู่ในเกณฑ์ดี",
      background: CustomColor.pink1,
      foreground: CustomColor.pink2,
    ),
    StatCardData(
      iconPath: AppIcons.duotone.pulse,
      title: "การแกว่งตัว",
      value: "82/52",
      description: "ระยะการแกว่งตัว",
      background: CustomColor.blue1,
      foreground: CustomColor.blue5,
    ),
    StatCardData(
      iconPath: AppIcons.duotone.graphUp,
      title: "ค่าสูงสุด",
      value: "85/55",
      description: "เมื่อวันที่ 19",
      background: CustomColor.red5,
      foreground: CustomColor.red4,
    ),
    StatCardData(
      iconPath: AppIcons.duotone.graphDown,
      title: "ค่าต่ำสุด",
      value: "80/50",
      description: "เมื่อวันที่ 14",
      background: CustomColor.purple3,
      foreground: CustomColor.purple2,
    ),
  ];

  List<StatCardData> get data => _data;

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }
}
