import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/core/services/media_service.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/data/blood_pressure/model/record_model.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/feature/record/presentation/record_viewModel.dart';
import 'package:dun_diary_app/feature/record/presentation/widgets/bp_card/bp_card_layout.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_box_icon.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_popup_menu.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:dun_diary_app/shared/widgets/custom/svg/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/ui/guage/guage.dart';
import 'package:dun_diary_app/shared/widgets/ui/picker/date_picker.dart';
import 'package:dun_diary_app/shared/widgets/ui/picker/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => RecordViewmodel(
        repository: context.read<BloodPressureRepository>(),
        authService: context.read<AuthService>(),
        mediaService: context.read<MediaService>(),
        networkInfo: context.read<NetworkInfo>(),
      ),
      child: const RecordScreen(),
    );
  }

  static Widget createWithArgs(BloodPressure bp) {
    return ChangeNotifierProvider(
      create: (context) {
        final viewModel = RecordViewmodel(
          repository: context.read<BloodPressureRepository>(),
          authService: context.read<AuthService>(),
          mediaService: context.read<MediaService>(),
          networkInfo: context.read<NetworkInfo>(),
        );
        viewModel.setBPValue(bp);
        return viewModel;
      },
      child: const RecordScreen(),
    );
  }

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  bool _isMenuOpen = false;
  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<RecordViewmodel>();
    return CustomScaffold(
      appBar: MainAppBar(
        title: AppStrings.record.recordBloodPressure,
        showBack: true,
        backIconPath: AppIcons.outline.x,
        onBackPressed: () => NavigationService.instance.goBack(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 36),
        child: Column(
          children: [
            Consumer<RecordViewmodel>(
              builder: (context, viewModel, child) {
                return CustomCard(
                  content: BpCardLayout(
                    sys: viewModel.bpValue.sys,
                    dia: viewModel.bpValue.dia,
                    pul: viewModel.bpValue.pul,
                    onSysChanged: (val) => viewModel.updateSys(val),
                    onDiaChanged: (val) => viewModel.updateDia(val),
                    onPulChanged: (val) => viewModel.updatePul(val),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Selector<RecordViewmodel, int>(
              selector: (_, viewModel) => viewModel.level,
              builder: (context, level, child) => CustomCard(
                title: BloodPressureUtils.mapLevelLabel(level),
                titleFontSize: 21,
                titleTextAlign: TextAlign.center,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                content: BloodPressureGauge(level: level),
              ),
            ),

            const SizedBox(height: 25),

            // Date time picker
            Selector<RecordViewmodel, DateTime>(
              selector: (_, viewModel) => viewModel.recordDate,
              builder: (context, recordDate, child) => Row(
                children: [
                  Expanded(
                    child: DatePicker(
                      selectedDate: recordDate,
                      onDateTimeChanged: (val) => viewModel.setRecordDate(val),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TimePicker(
                      selectedDate: recordDate,
                      onDateTimeChanged: (val) => viewModel.setRecordDate(val),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomPopupMenuButton<ImageSource>(
                  openAbove: true,
                  icon: CustomBoxIcon(
                    iconPath: AppIcons.outline.camera,
                    activeIconPath: AppIcons.outline.x,
                    isActive: _isMenuOpen,
                  ),
                  onOpened: () => setState(() => _isMenuOpen = true),
                  onCanceled: () => setState(() => _isMenuOpen = false),
                  onSelected: (ImageSource source) {
                    viewModel.handlePickImage(source);
                    setState(() {
                      _isMenuOpen = false;
                    });
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

                Selector<RecordViewmodel, bool>(
                  selector: (_, viewModel) => viewModel.isLoading,
                  builder: (context, isLoading, child) => CustomButton(
                    text: isLoading
                        ? AppStrings.common.saving
                        : AppStrings.common.save,
                    type: CustomButtonType.fill,
                    backgroundColor: isLoading
                        ? CustomColor.gray400
                        : CustomColor.accentColor,
                    boxShadow: [DropShadow.drop_thumb],
                    onPressed: isLoading ? () {} : () => viewModel.saveResult(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
