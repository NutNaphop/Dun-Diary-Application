import 'package:dun_diary_app/core/mixins/record_navigation_mixin.dart';
import 'package:flutter/material.dart';

class MainViewModel extends ChangeNotifier with RecordNavigationMixin {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  // ฟังก์ชันสลับ Tab
  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
