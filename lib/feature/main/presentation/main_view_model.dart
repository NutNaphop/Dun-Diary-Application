import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:flutter/material.dart';

class MainViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (index == 2) {
      redirectToRecord();
      return;
    }

    _currentIndex = index;
    notifyListeners();
  }

  void redirectToRecord() {
    NavigationService.instance.pushNamed(AppRoutes.record);
  }
}
