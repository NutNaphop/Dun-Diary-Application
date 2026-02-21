import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/core/recovery/recovery_flag_service.dart';
import 'package:dun_diary_app/data/user/repository/user_repository.dart';
import 'package:dun_diary_app/core/services/media_service.dart';
import 'package:dun_diary_app/core/services/flushbar_service.dart';
import 'package:dun_diary_app/feature/setting/presentation/recoveryMyDataScreen/recovery_my_data_viewModel.dart';
import 'package:dun_diary_app/feature/setting/presentation/recoveryMyDataScreen/widgets/recovery_error_section.dart';
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
        networkInfo: context.read<NetworkInfo>(),
        mediaService: context.read<MediaService>(),
        userRepository: context.read<UserRepository>(),
        authService: context.read<AuthService>(),
        bpRepository: context.read<BloodPressureRepository>(),
      ),
      child: const RecoveryMyDataScreen(),
    );
  }

  @override
  State<RecoveryMyDataScreen> createState() => _RecoveryMyDataScreenState();
}

class _RecoveryMyDataScreenState extends State<RecoveryMyDataScreen> {
  @override
  void initState() {
    super.initState();
    // เช็คว่ามี recovery ค้าง → auto-resume
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndResumeRecovery();
    });
  }

  Future<void> _checkAndResumeRecovery() async {
    final viewModel = context.read<RecoveryMyDataViewModel>();

    if (RecoveryFlagService.isRecoveryPending()) {
      final success = await viewModel.resumeRecovery();
      if (success) {
        FlushbarService.instance.showSuccess(
          AppStrings.setting.recoverySuccess,
        );
        NavigationService.instance.pushNamedAndRemoveUntil(AppRoutes.splash);
      } else {
        if (!viewModel.isResumeError) {
          // กู้ไม่สำเร็จจริงๆ → กลับไปหน้า main ปกติ
          FlushbarService.instance.showError(
            AppStrings.setting.cannotResumeRecovery,
          );
          NavigationService.instance.pushReplacementNamed(AppRoutes.main);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RecoveryMyDataViewModel>();
    final blockBack = viewModel.isRecovering || viewModel.isResumeError;

    return PopScope(
      canPop: !blockBack,
      child: CustomScaffold(
        appBar: MainAppBar(
          title: AppStrings.setting.recoveryTitle,
          showBack: !blockBack,
          onBackPressed: blockBack
              ? null
              : () => NavigationService.instance.goBack(),
        ),
        body: viewModel.isResumeError
            ? RecoveryErrorSection(
                viewModel: viewModel,
                onRetry: _checkAndResumeRecovery,
              )
            : (viewModel.recoveredUser == null
                  ? RecoveryScannerSection(viewModel: viewModel)
                  : RecoveryPreviewSection(viewModel: viewModel)),
      ),
    );
  }
}
