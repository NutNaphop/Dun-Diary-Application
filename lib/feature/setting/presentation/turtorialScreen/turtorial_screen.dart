import 'package:dun_diary_app/feature/setting/presentation/turtorialScreen/turtorial_screen_viewModel.dart';
import 'package:dun_diary_app/feature/setting/presentation/widgets/section/setting_menu_section.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TurtorialScreen extends StatefulWidget {
  const TurtorialScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => TurtorialScreenViewmodel(),
      child: const TurtorialScreen(),
    );
  }

  @override
  State<TurtorialScreen> createState() => _TurtorialScreenState();
}

class _TurtorialScreenState extends State<TurtorialScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TurtorialScreenViewmodel>();

    return CustomScaffold(
      appBar: MainAppBar(
        title: 'คู่มือการใช้งาน',
        showBack: true,
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ...viewModel.menuSections.map((section) {
              return SettingMenuSection(section: section);
            }),
          ],
        ),
      ),
    );
  }
}
