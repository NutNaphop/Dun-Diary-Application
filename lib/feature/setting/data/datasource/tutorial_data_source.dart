import 'package:dun_diary_app/feature/setting/data/datasource/topics/analyze_topics.dart';
import 'package:dun_diary_app/feature/setting/data/datasource/topics/export_topics.dart';
import 'package:dun_diary_app/feature/setting/data/datasource/topics/history_topics.dart';
import 'package:dun_diary_app/feature/setting/data/datasource/topics/record_topics.dart';
import 'package:dun_diary_app/feature/setting/data/datasource/topics/recovery_topics.dart';
import 'package:dun_diary_app/feature/setting/data/model/tutorial_topic.dart';
import 'package:dun_diary_app/feature/setting/data/model/tutorial_content_block.dart';

class TutorialStep {
  final String imagePath;
  final String descriptionTitle;
  final List<TutorialContentBlock> blocks;

  TutorialStep({
    required this.imagePath,
    required this.descriptionTitle,
    required this.blocks,
  });
}

class TutorialDataSource {
  static List<TutorialStep> getStepsForTopic(TutorialTopic topic) {
    switch (topic) {
      case TutorialTopic.recordBloodPressure:
        return recordTopics;

      case TutorialTopic.analyzeData:
        return analyzeTopics;

      case TutorialTopic.history:
        return historyTopics;

      case TutorialTopic.recoveryData:
        return recoveryTopics;

      case TutorialTopic.exportData:
        return exportTopics;
    }
  }
}
