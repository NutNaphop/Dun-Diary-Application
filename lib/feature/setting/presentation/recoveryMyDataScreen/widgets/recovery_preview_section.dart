import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/services/flushbar_service.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/feature/setting/presentation/recoveryMyDataScreen/recovery_my_data_viewModel.dart';
import 'package:dun_diary_app/feature/setting/presentation/recoveryMyDataScreen/widgets/confirmRecoveryDialog.dart';
import 'package:dun_diary_app/feature/setting/presentation/widgets/card/profile_card.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/dialog/custom_dialog.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecoveryPreviewSection extends StatelessWidget {
  final RecoveryMyDataViewModel viewModel;

  const RecoveryPreviewSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.recoveredUser == null) return const SizedBox();

    final user = viewModel.recoveredUser!;

    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 52),
            child: Column(
              children: [
                // ดาวสีเหลือง
                SVGImage(
                  path: AppIcons.duotone.starCircle,
                  width: 100,
                  height: 100,
                  color: const Color.fromARGB(255, 248, 199, 2),
                ),
                const SizedBox(height: 24),

                CustomText(
                  text: AppStrings.setting.accountFound,
                  fontSize: Dimension.fontSizes.h1,
                  fontWeight: Dimension.fontWeights.bold,
                ),
                const SizedBox(height: 12),

                CustomText(
                  text: AppStrings.setting.readyToRecoverDesc,
                  fontSize: Dimension.fontSizes.h2,
                  color: CustomColor.gray600,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                AbsorbPointer(
                  absorbing: true,
                  child: ProfileCard(onTap: () {}, userName: user.displayName),
                ),

                // === Recovery Progress UI ===
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // ====== ONLY THIS PART REBUILDS ON PROGRESS ======
                      Selector<RecoveryMyDataViewModel, _ProgressState>(
                        selector: (context, vm) => _ProgressState(
                          isRecovering: vm.isRecovering,
                          progress: vm.recoveryProgress,
                          status: vm.recoveryStatus,
                        ),
                        builder: (context, state, child) {
                          if (!state.isRecovering)
                            return const SizedBox.shrink();

                          return Column(
                            children: [
                              LinearProgressIndicator(
                                value: state.progress,
                                minHeight: 12,
                                borderRadius: BorderRadius.circular(6),
                                backgroundColor: CustomColor.blue6,
                                color: CustomColor.blue3,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: state.status,
                                    fontSize: Dimension.fontSizes.sm,
                                    color: CustomColor.gray600,
                                  ),
                                  CustomText(
                                    text: "${(state.progress * 100).toInt()}%",
                                    fontSize: Dimension.fontSizes.sm,
                                    fontWeight: Dimension.fontWeights.bold,
                                    color: CustomColor.blue3,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ====== ONLY HIDE THE BUTTON IF RECOVERING ======
        Selector<RecoveryMyDataViewModel, bool>(
          selector: (context, vm) => vm.isRecovering,
          builder: (context, isRecovering, child) {
            if (isRecovering) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: CustomButton(
                text: AppStrings.setting.confirmRecoveryBtn,
                type: CustomButtonType.fill,
                onPressed: () {
                  _showRecoveryConfirmDialog(context);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _showRecoveryConfirmDialog(BuildContext context) async {
    final result = await CustomDialog.show<bool>(
      context,
      child: ConfirmRecoveryDialog(),
    );

    if (result == true) {
      final success = await viewModel.confirmRecovery();
      if (success) {
        FlushbarService.instance.showSuccess(
          AppStrings.setting.recoverySuccess,
        );
        NavigationService.instance.pushNamedAndRemoveUntil(AppRoutes.splash);
      }
    }
  }
}

class _ProgressState {
  final bool isRecovering;
  final double progress;
  final String status;

  _ProgressState({
    required this.isRecovering,
    required this.progress,
    required this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ProgressState &&
          runtimeType == other.runtimeType &&
          isRecovering == other.isRecovering &&
          progress == other.progress &&
          status == other.status;

  @override
  int get hashCode => Object.hash(isRecovering, progress, status);
}
