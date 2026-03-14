import 'package:dun_diary_app/feature/setting/data/model/tutorial_topic.dart';
import 'package:dun_diary_app/feature/setting/data/tutorial_data_source.dart';
import 'package:dun_diary_app/feature/setting/presentation/tutorialScreen/widgets/tutorial_layout_template.dart';
import 'package:flutter/material.dart';

class TutorialViewScreen extends StatelessWidget {
  final TutorialTopic topic;

  const TutorialViewScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final steps = TutorialDataSource.getStepsForTopic(topic);

    return TutorialLayoutTemplate(
      title: topic.title,
      itemCount: steps.length,
      carouselBuilder: (context, index) {
        return Container(
          height: 343,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFDEF4F5), Color(0xFF9EDCDE)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            // TODO: Replace Text with Image.asset(steps[index].imagePath) when images are ready
            child: Text(
              "รูปภาพประกอบ ${index + 1}",
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
      bottomContentBuilder: (context, index) {
        final step = steps[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step.descriptionTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            ...step.instructions.map(
              (text) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(text, style: const TextStyle(height: 1.5)),
              ),
            ),
          ],
        );
      },
      onFinished: () {}, // Handled by template's pop
    );
  }
}
