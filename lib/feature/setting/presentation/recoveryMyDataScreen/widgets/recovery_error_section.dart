import 'package:dun_diary_app/feature/setting/presentation/recoveryMyDataScreen/recovery_my_data_viewModel.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecoveryErrorSection extends StatelessWidget {
  final RecoveryMyDataViewModel viewModel;
  final VoidCallback onRetry;

  const RecoveryErrorSection({
    super.key,
    required this.viewModel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 80,
            color: CustomColor.gray500,
          ),
          const SizedBox(height: 24),
          CustomText(
            text: AppStrings.setting.resumePausedTitle,
            fontSize: Dimension.fontSizes.h1,
            fontWeight: Dimension.fontWeights.bold,
          ),
          const SizedBox(height: 12),
          CustomText(
            text: AppStrings.setting.resumePausedDesc,
            color: CustomColor.gray600,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Selector<RecoveryMyDataViewModel, bool>(
            selector: (context, vm) => vm.isLoading,
            builder: (context, isLoading, child) {
              return CustomButton(
                text: AppStrings.setting.retryResumeBtn,
                type: CustomButtonType.fill,
                onPressed: isLoading ? null : onRetry,
              );
            },
          ),
        ],
      ),
    );
  }
}
