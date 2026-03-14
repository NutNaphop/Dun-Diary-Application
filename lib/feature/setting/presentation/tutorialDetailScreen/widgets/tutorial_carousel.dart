import 'package:dun_diary_app/feature/setting/data/datasource/tutorial_data_source.dart';
import 'package:flutter/material.dart';

class TutorialCarousel extends StatelessWidget {
  final List<TutorialStep> steps;
  final ValueChanged<int> onPageChanged;
  final PageController pageController;
  final double viewportFraction;

  const TutorialCarousel({
    super.key,
    required this.steps,
    required this.onPageChanged,
    required this.pageController,
    this.viewportFraction = 0.85,
  });

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) return const SizedBox.shrink();

    return PageView.builder(
      controller: pageController,
      itemCount: steps.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        // final step = steps[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            height: 343,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFDEF4F5), Color(0xFF9EDCDE)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              // TODO: Replace Text with Image.asset(step.imagePath) when images are ready
              child: Text(
                "รูปภาพประกอบ ${index + 1}",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
