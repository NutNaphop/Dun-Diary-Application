import 'package:dun_diary_app/feature/setting/presentation/recoverySettingScreen/recovery_setting_viewModel.dart';
import 'package:dun_diary_app/feature/setting/presentation/widgets/section/setting_menu_section.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class RecoverySettingScreen extends StatelessWidget {
  const RecoverySettingScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => RecoverySettingViewmodel(),
      child: const RecoverySettingScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<RecoverySettingViewmodel>();

    return CustomScaffold(
      usePadding: false,
      appBar: MainAppBar(
        title: 'การสำรองข้อมูลและกู้ข้อมูล',
        showBack: true,
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 26),
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
