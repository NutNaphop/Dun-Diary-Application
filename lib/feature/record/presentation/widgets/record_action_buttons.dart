import 'package:dun_diary_app/feature/record/presentation/record_viewModel.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_box_icon.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_popup_menu.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RecordActionButtons extends StatelessWidget {
  const RecordActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordViewmodel>(
      builder: (context, vm, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!vm.hasExistingData) ...[
              Selector<RecordViewmodel, bool>(
                selector: (_, viewModel) => viewModel.isMenuOpen,
                builder: (context, isMenuOpen, child) =>
                    CustomPopupMenuButton<ImageSource>(
                      openAbove: true,
                      icon: CustomBoxIcon(
                        iconPath: AppIcons.outline.camera,
                        backgroundColor: vm.isMenuOpen
                            ? CustomColor.gray500
                            : CustomColor.primaryColor,
                        activeIconPath: AppIcons.outline.x,
                        isActive: isMenuOpen,
                      ),
                      onOpened: () => vm.setMenuOpen(true),
                      onCanceled: () => vm.setMenuOpen(false),
                      onSelected: (source) {
                        vm.handlePickImage(source);
                        vm.setMenuOpen(false);
                      },
                      items: [
                        CustomPopupMenuItem(
                          value: ImageSource.camera,
                          title: AppStrings.record.snapPhoto,
                          icon: SVGImage(
                            path: AppIcons.duotone.camera,
                            width: 22,
                            height: 22,
                            color: CustomColor.accentColor,
                          ),
                        ),
                        CustomPopupMenuItem(
                          value: ImageSource.gallery,
                          title: AppStrings.record.uploadPhoto,
                          icon: SVGImage(
                            path: AppIcons.duotone.image,
                            width: 22,
                            height: 22,
                            color: CustomColor.accentColor,
                          ),
                        ),
                      ],
                    ),
              ),
              const SizedBox(height: 20),
            ],

            Selector<RecordViewmodel, bool>(
              selector: (_, viewModel) => viewModel.isLoading,
              builder: (context, isLoading, child) => vm.hasExistingData
                  ? Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: AppStrings.common.cancel,
                            type: CustomButtonType.outline,
                            onPressed: isLoading
                                ? () {}
                                : () => vm.cancelEditMode(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            text: isLoading
                                ? AppStrings.common.saving
                                : AppStrings.common.save,
                            type: CustomButtonType.fill,
                            backgroundColor: isLoading
                                ? CustomColor.gray400
                                : CustomColor.accentColor,
                            boxShadow: [DropShadow.drop_thumb],
                            onPressed: isLoading
                                ? () {}
                                : () => vm.saveResult(),
                          ),
                        ),
                      ],
                    )
                  : CustomButton(
                      text: isLoading
                          ? AppStrings.common.saving
                          : AppStrings.common.save,
                      type: CustomButtonType.fill,
                      backgroundColor: isLoading
                          ? CustomColor.gray400
                          : CustomColor.accentColor,
                      boxShadow: [DropShadow.drop_thumb],
                      onPressed: isLoading ? () {} : () => vm.saveResult(),
                    ),
            ),
          ],
        );
      },
    );
  }
}
