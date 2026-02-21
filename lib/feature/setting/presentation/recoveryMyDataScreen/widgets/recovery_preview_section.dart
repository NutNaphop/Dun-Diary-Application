import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/services/flushbar_service.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/feature/setting/presentation/recoveryMyDataScreen/recovery_my_data_viewModel.dart';
import 'package:dun_diary_app/feature/setting/presentation/widgets/card/profile_card.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_image.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/dialog/custom_dialog.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:flutter/material.dart';

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
                if (viewModel.isRecovering) ...[
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: viewModel.recoveryProgress,
                            minHeight: 8,
                            backgroundColor: CustomColor.gray200,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              CustomColor.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        CustomText(
                          text: viewModel.recoveryStatus,
                          fontSize: Dimension.fontSizes.rg,
                          color: CustomColor.gray600,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // ปุ่มยืนยันการกู้ข้อมูล (ซ่อนตอน recovering)
        if (!viewModel.isRecovering)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: CustomButton(
              text: AppStrings.setting.confirmRecoveryBtn,
              type: CustomButtonType.fill,
              onPressed: () {
                _showRecoveryConfirmDialog(context);
              },
            ),
          ),
      ],
    );
  }

  Future<void> _showRecoveryConfirmDialog(BuildContext context) async {
    final result = await CustomDialog.show<bool>(
      context,
      child: CustomDialog(
        title: AppStrings.setting.confirmRecoveryTitle,
        description: AppStrings.setting.confirmRecoveryWarning,
        primaryButtonText: AppStrings.setting.understandAndConfirm,
        secondaryButtonText: AppStrings.common.cancel,
        content: SVGImage(path: AppImages.faq, width: 163, height: 120),
      ),
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
