import 'package:dun_diary_app/shared/style/color.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;

  // ✅ Key Features: ควบคุม Padding ได้
  final bool usePadding;
  final bool useSafeArea;

  // Color
  final Color backgroundColor;

  const CustomScaffold({
    super.key,
    required this.body,
    this.title,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.actions,
    this.usePadding = true, // default เป็น true
    this.useSafeArea = true,
    this.backgroundColor = CustomColor.gray100,
  });

  @override
  Widget build(BuildContext context) {
    const double defaultPadding = 16.0;

    Widget content = body;

    if (usePadding) {
      content = Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: content,
      );
    }

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: content,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
