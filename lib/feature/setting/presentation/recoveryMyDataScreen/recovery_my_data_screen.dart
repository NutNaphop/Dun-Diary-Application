import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/data/user/repository/user_repository.dart';
import 'package:dun_diary_app/core/services/media_service.dart';
import 'package:dun_diary_app/feature/setting/presentation/recoveryMyDataScreen/recovery_my_data_viewModel.dart';
import 'package:dun_diary_app/feature/setting/presentation/recoveryMyDataScreen/widgets/recovery_preview_section.dart';
import 'package:dun_diary_app/feature/setting/presentation/recoveryMyDataScreen/widgets/recovery_scanner_section.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecoveryMyDataScreen extends StatefulWidget {
  const RecoveryMyDataScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => RecoveryMyDataViewModel(
        mediaService: context.read<MediaService>(),
        userRepository: context.read<UserRepository>(),
      ),
      child: const RecoveryMyDataScreen(),
    );
  }

  @override
  State<RecoveryMyDataScreen> createState() => _RecoveryMyDataScreenState();
}

class _RecoveryMyDataScreenState extends State<RecoveryMyDataScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RecoveryMyDataViewModel>();
    return CustomScaffold(
      appBar: MainAppBar(
        title: AppStrings.setting.recoveryTitle,
        showBack: true,
        onBackPressed: () => NavigationService.instance.goBack(),
      ),
      body: viewModel.recoveredUser == null
          ? RecoveryScannerSection(viewModel: viewModel)
          : RecoveryPreviewSection(viewModel: viewModel),
    );
  }
}
