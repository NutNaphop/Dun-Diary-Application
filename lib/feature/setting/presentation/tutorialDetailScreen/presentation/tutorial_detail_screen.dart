import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/feature/setting/data/model/tutorial_topic.dart';
import 'package:dun_diary_app/feature/setting/presentation/tutorialDetailScreen/presentation/tutorial_detail_viewModel.dart';
import 'package:dun_diary_app/feature/setting/presentation/tutorialDetailScreen/widgets/tutorial_block_widget.dart';
import 'package:dun_diary_app/feature/setting/presentation/tutorialDetailScreen/widgets/tutorial_carousel.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TutorialViewScreen extends StatefulWidget {
  const TutorialViewScreen({super.key});

  static Widget create(TutorialTopic topic) {
    return ChangeNotifierProvider(
      create: (context) => TutorialDetailViewModel()..init(topic),
      child: TutorialViewScreen(),
    );
  }

  @override
  State<TutorialViewScreen> createState() => _TutorialViewScreenState();
}

class _TutorialViewScreenState extends State<TutorialViewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TutorialDetailViewModel>();
    final steps = viewModel.steps;
    final currentPage = viewModel.currentPage;

    if (steps.isEmpty) {
      return CustomScaffold(
        appBar: MainAppBar(
          title: viewModel.topic.title,
          showBack: true,
          centerTitle: true,
          onBackPressed: () => NavigationService.instance.goBack(),
        ),
        body: const Center(child: Text("ไม่พบข้อมูล Tutorial")),
      );
    }

    final currentStep = steps[currentPage];

    return CustomScaffold(
      backgroundColor: CustomColor.white,
      usePadding: false,
      appBar: MainAppBar(
        title: viewModel.topic.title,
        showBack: true,
        centerTitle: true,
        onBackPressed: () {
          NavigationService.instance.goBack();
        },
      ),
      body: Column(
        children: [
          // 1. Carousel Widget
          Expanded(
            flex: 11,
            child: TutorialCarousel(
              steps: steps,
              pageController: viewModel.pageController,
              onPageChanged: (index) {
                viewModel.setCurrentPage(index);
              },
            ),
          ),
          const SizedBox(height: 8),

          // 2. Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              steps.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: currentPage == index ? 7 : 5,
                height: currentPage == index ? 7 : 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == index
                      ? CustomColor.gray500
                      : CustomColor.gray300,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 3. Content Detail for current step
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: currentStep.descriptionTitle,
                    fontSize: Dimension.fontSizes.subH1,
                    fontWeight: Dimension.fontWeights.semiBold,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: currentStep.blocks
                          .map((block) => TutorialBlockWidget(block: block))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Buttons Flow
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 24.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'ย้อนกลับ',
                    type: CustomButtonType.outline,
                    onPressed: currentPage > 0
                        ? () => viewModel.previousPage()
                        : () => NavigationService.instance.goBack(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: currentPage == steps.length - 1
                        ? 'เสร็จสิ้น'
                        : 'ถัดไป',
                    type: CustomButtonType.fill,
                    onPressed: currentPage == steps.length - 1
                        ? () => NavigationService.instance.goBack()
                        : () => viewModel.nextPage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
