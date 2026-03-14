import 'package:dun_diary_app/feature/setting/data/model/tutorial_topic.dart';
import 'package:dun_diary_app/feature/setting/data/datasource/tutorial_data_source.dart';
import 'package:flutter/material.dart';

class TutorialDetailViewModel extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  List<TutorialStep> _steps = [];
  List<TutorialStep> get steps => _steps;

  TutorialTopic _topic = TutorialTopic.recordBloodPressure;
  TutorialTopic get topic => _topic;

  late PageController pageController;

  void init(TutorialTopic topic) {
    _topic = topic;
    _steps = TutorialDataSource.getStepsForTopic(topic);
    pageController = PageController(viewportFraction: 0.85);
  }

  void setCurrentPage(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < _steps.length - 1) {
      pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
