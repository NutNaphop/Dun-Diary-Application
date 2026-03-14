import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class TutorialLayoutTemplate extends StatefulWidget {
  final String title;
  final int itemCount;
  final Widget Function(BuildContext context, int index) carouselBuilder;
  final Widget Function(BuildContext context, int index) bottomContentBuilder;
  final VoidCallback onFinished;
  final double viewportFraction;

  const TutorialLayoutTemplate({
    super.key,
    required this.title,
    required this.itemCount,
    required this.carouselBuilder,
    required this.bottomContentBuilder,
    required this.onFinished,
    this.viewportFraction = 0.85,
  });

  @override
  State<TutorialLayoutTemplate> createState() => _TutorialLayoutTemplateState();
}

class _TutorialLayoutTemplateState extends State<TutorialLayoutTemplate> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: widget.viewportFraction);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < widget.itemCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onFinished();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: CustomColor.white,
      usePadding: false, // ปิด Padding อัตโนมัติ เพื่อให้ PageView กินพื้นที่เต็มขอบจอ
      appBar: AppBar(
        backgroundColor: CustomColor.white,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: widget.title,
          fontSize: Dimension.fontSizes.h2,
          fontWeight: Dimension.fontWeights.semiBold,
          color: CustomColor.gray900,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: CustomColor.gray900, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // ส่วนของ Carousel (รูปภาพ/สื่อ)
          Expanded(
            flex: 5,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.itemCount,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  child: widget.carouselBuilder(context, index),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // จุดบอกตำแหน่ง (Indicator)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.itemCount,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 8 : 6,
                height: _currentPage == index ? 8 : 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? CustomColor.gray500 : CustomColor.gray300,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // ส่วนของเนื้อหาและข้อความอธิบาย
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: widget.bottomContentBuilder(context, _currentPage),
            ),
          ),
          // ปุ่มควบคุมด้านล่าง
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'ย้อนกลับ',
                    type: CustomButtonType.outline,
                    onPressed: _currentPage > 0 ? _previousPage : () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: _currentPage == widget.itemCount - 1 ? 'เสร็จสิ้น' : 'ถัดไป',
                    type: CustomButtonType.fill,
                    onPressed: _currentPage == widget.itemCount - 1 ? widget.onFinished : _nextPage,
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
