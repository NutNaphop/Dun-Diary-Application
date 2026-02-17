import 'package:dun_diary_app/feature/setting/presentation/setting_viewModel.dart';
import 'package:dun_diary_app/feature/setting/presentation/widgets/section/setting_menu_section.dart';
import 'package:dun_diary_app/feature/setting/presentation/widgets/card/profile_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => SettingViewmodel(),
      child: const SettingScreen(),
    );
  }

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SettingViewmodel>();
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          spacing: 10,
          children: [
            ProfileCard(),
            ...viewModel.menuSections.map((section) {
              return SettingMenuSection(section: section);
            }),
          ],
        ),
      ),
    );
  }
}
