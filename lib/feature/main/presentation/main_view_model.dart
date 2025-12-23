import 'package:flutter/material.dart';

class MainViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  // ฟังก์ชันสลับ Tab
  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}