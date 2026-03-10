import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/feature/setting/presentation/recoveryMyDataScreen/recovery_my_data_viewModel.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_image.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecoveryScannerSection extends StatelessWidget {
  final RecoveryMyDataViewModel viewModel;

  const RecoveryScannerSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // QR Upload Placeholder
              SVGImage(path: AppImages.upload, width: 186, height: 186),
              const SizedBox(height: 28),

              // Title
              CustomText(
                text: AppStrings.setting.uploadQRTitle,
                fontSize: Dimension.fontSizes.h1,
                fontWeight: Dimension.fontWeights.bold,
                color: CustomColor.gray900,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Description
              CustomText(
                text: AppStrings.setting.uploadQRDescription,
                fontSize: Dimension.fontSizes.h2,
                fontWeight: Dimension.fontWeights.regular,
                color: CustomColor.gray600,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Selector<RecoveryMyDataViewModel, bool>(
            selector: (context, vm) => vm.isLoading,
            builder: (context, isLoading, child) {
              return Column(
                children: [
                  // Primary: Pick from Album
                  CustomButton(
                    text: AppStrings.setting.selectFromAlbum,
                    type: CustomButtonType.fill,
                    leadingIcon: SVGImage(
                      path: AppIcons.outline.image,
                      width: 20,
                      height: 20,
                      color: CustomColor.white,
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            await viewModel.pickImageAndDecodeQR();
                          },
                  ),
                  const SizedBox(height: 12),

                  // Secondary: Open Camera Scanner
                  CustomButton(
                    text: AppStrings.setting.scanQRCode,
                    type: CustomButtonType.outline,
                    borderColor: CustomColor.primaryColor,
                    textStyle: TextStyle(
                      color: CustomColor.primaryColor,
                      fontSize: Dimension.fontSizes.h2,
                      fontWeight: Dimension.fontWeights.bold,
                    ),
                    leadingIcon: SVGImage(
                      path: AppIcons.outline.camera,
                      width: 20,
                      height: 20,
                      color: CustomColor.primaryColor,
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            final scannedData = await NavigationService.instance
                                .pushNamed(AppRoutes.setting.qrScanner);
                            if (scannedData != null && scannedData is String) {
                              await viewModel.processScannedQR(scannedData);
                            }
                          },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
