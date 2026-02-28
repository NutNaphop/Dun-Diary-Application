import 'package:dun_diary_app/feature/record/presentation/record_viewModel.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_image.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_box_icon.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_popup_menu.dart';
import 'package:dun_diary_app/shared/widgets/custom/dialog/custom_dialog.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ViewAction { edit, delete }

class RecordViewMenu extends StatelessWidget {
  const RecordViewMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordViewmodel>(
      builder: (context, vm, child) {
        return Align(
          alignment: Alignment.bottomRight,
          child: CustomPopupMenuButton<ViewAction>(
            menuMinWidth: 205,
            openAbove: true,
            icon: CustomBoxIcon(
              iconPath: AppIcons.outline.pen,
              backgroundColor: vm.isMenuOpen
                  ? CustomColor.gray500
                  : CustomColor.primaryColor,
              activeIconPath: AppIcons.outline.x,
              isActive: vm.isMenuOpen,
            ),
            onOpened: () => vm.setMenuOpen(true),
            onCanceled: () => vm.setMenuOpen(false),
            onSelected: (action) {
              if (action == ViewAction.edit) {
                vm.enterEditMode();
              } else if (action == ViewAction.delete) {
                _showDeleteConfirmDialog(context, vm);
              }
            },
            items: [
              CustomPopupMenuItem<ViewAction>(
                value: ViewAction.edit,
                title: AppStrings.common.edit,
                icon: SVGImage(
                  path: AppIcons.duotone.pen,
                  width: 22,
                  height: 22,
                  color: CustomColor.infoColor,
                ),
              ),
              CustomPopupMenuItem<ViewAction>(
                value: ViewAction.delete,
                title: AppStrings.record.delete,
                icon: SVGImage(
                  path: AppIcons.duotone.bin,
                  width: 22,
                  height: 22,
                  color: CustomColor.highLevel3CrisisColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmDialog(
    BuildContext context,
    RecordViewmodel viewModel,
  ) async {
    final result = await CustomDialog.show<bool>(
      context,
      child: CustomDialog(
        title: AppStrings.record.confirmDeleteTitle,
        description: AppStrings.record.confirmDeleteDesc,
        primaryButtonText: AppStrings.record.delete,
        secondaryButtonText: AppStrings.common.cancel,
        content: SVGImage(
          path: AppImages.confirmDelete,
          width: 163,
          height: 120,
        ),
      ),
    );

    if (result == true) {
      viewModel.deleteRecord();
    } else {
      viewModel.setMenuOpen(false);
    }
  }
}
