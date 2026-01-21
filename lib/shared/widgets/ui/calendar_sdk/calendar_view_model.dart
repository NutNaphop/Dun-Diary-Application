import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'models/calendar_types.dart';
import 'utils/calendar_utils.dart';

class CalendarViewModel extends ChangeNotifier {
  final CalendarType type;

  late CalendarView _currentView;
  late DateTime _selectedDate;
  late DateTime _focusedDate;

  CalendarViewModel({
    required this.type,
    required DateTime initialDate,
  }) {
    initializeDateFormatting('th_TH');
    _selectedDate = initialDate;
    _focusedDate = initialDate;
    _initView();
  }

  // Getters
  CalendarView get currentView => _currentView;
  DateTime get selectedDate => _selectedDate;
  DateTime get focusedDate => _focusedDate;

  void _initView() {
    switch (type) {
      case CalendarType.day:
        _currentView = CalendarView.day;
        break;
      case CalendarType.week:
        _currentView = CalendarView.week;
        break;
      case CalendarType.month:
        _currentView = CalendarView.month;
        break;
      case CalendarType.year:
        _currentView = CalendarView.year;
        break;
    }
  }

  void onGoToToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _selectedDate = today;
    _focusedDate = today;
    _initView(); // กลับไปหน้า View เริ่มต้นของ Type นั้นๆ
    notifyListeners();
  }

  void onHeaderMonthTap() {
    _currentView = CalendarView.month;
    notifyListeners();
  }

  void onHeaderYearTap() {
    _currentView = CalendarView.year;
    notifyListeners();
  }

  void onYearSelected(int year) {
    _focusedDate = CalendarUtils.clampDay(year, _focusedDate.month, _focusedDate.day);

    if (type == CalendarType.year) {
      _selectedDate = CalendarUtils.clampDay(year, _selectedDate.month, _selectedDate.day);
    } else if (type == CalendarType.month) {
      _currentView = CalendarView.month;
    } else if (type == CalendarType.week) {
      _currentView = CalendarView.week;
    } else {
      _currentView = CalendarView.day;
    }
    notifyListeners();
  }

  void onMonthSelected(int month) {
    _focusedDate = CalendarUtils.clampDay(_focusedDate.year, month, _focusedDate.day);
    if (type == CalendarType.month) {
      _selectedDate = CalendarUtils.clampDay(_focusedDate.year, month, _selectedDate.day);
    } else if (type == CalendarType.day) {
      _currentView = CalendarView.day;
    } else {
      _currentView = CalendarView.week;
    }
    notifyListeners();
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    _selectedDate = selected;
    _focusedDate = focused;
    notifyListeners();
  }

  void onPageChanged(DateTime focused) {
    _focusedDate = focused;
    notifyListeners();
  }
}