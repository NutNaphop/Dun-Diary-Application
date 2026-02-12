import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/core/services/media_service.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
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
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:dun_diary_app/shared/widgets/ui/guage/guage.dart';
import 'package:dun_diary_app/shared/widgets/ui/picker/date_picker.dart';
import 'package:dun_diary_app/shared/widgets/ui/picker/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RecordScreen extends StatefulWidget {
  final BPRecord? record;

  const RecordScreen({super.key, this.record});

  // Factory สำหรับ Create Mode
  static Widget create() {
    return _createProvider(null);
  }

  // Factory สำหรับ Edit Mode
  static Widget createWithRecord(BPRecord record) {
    return _createProvider(record);
  }

  // Helper สร้าง Provider พร้อม init ข้อมูล
  static Widget _createProvider(BPRecord? record) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = RecordViewmodel(
          repository: context.read<BloodPressureRepository>(),
          authService: context.read<AuthService>(),
          mediaService: context.read<MediaService>(),
          networkInfo: context.read<NetworkInfo>(),
        );
        vm.init(record);
        return vm;
      },
      child: const RecordScreen(),
    );
  }

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  bool _isMenuOpen = false;
  bool _isEditMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    // Use watch to rebuild when state changes (e.g. isReadOnly)
    final viewModel = context.watch<RecordViewmodel>();
    final isReadOnly = viewModel.isReadOnly;

    return CustomScaffold(
      appBar: MainAppBar(
        title: isReadOnly
            ? "รายละเอียด"
            : (viewModel.hasExistingData ? "แก้ไขข้อมูล" : "บันทึกความดัน"),
        showBack: true,
        backIconPath: AppIcons.outline.x,
        onBackPressed: () => NavigationService.instance.goBack(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 36),
        child: Column(
          children: [
            AbsorbPointer(
              absorbing: isReadOnly,
              child: Consumer<RecordViewmodel>(
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
            isReadOnly
                ? _buildViewMenu(viewModel)
                : _buildActionButtons(viewModel),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------
  // 💾 Action Mode: ปุ่ม Save (และปุ่มกล้อง)
  // -----------------------------------------------------
  Widget _buildActionButtons(RecordViewmodel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, // จัดชิดขวา
      mainAxisSize: MainAxisSize.min,
      children: [
        // 📸 1. ปุ่มกล้อง (โชว์เฉพาะตอนสร้างใหม่ หรือถ้าอยากให้แก้รูปได้ก็เอา if ออก)
        if (!vm.hasExistingData) ...[
          CustomPopupMenuButton<ImageSource>(
            openAbove: true,
            icon: CustomBoxIcon(
              iconPath: AppIcons.outline.camera,
              activeIconPath: AppIcons.outline.x,
              isActive: _isMenuOpen,
            ),
            onOpened: () => setState(() => _isMenuOpen = true),
            onCanceled: () => setState(() => _isMenuOpen = false),
            onSelected: (source) {
              vm.handlePickImage(source);
              setState(() => _isMenuOpen = false);
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
          const SizedBox(height: 20),
        ],

        // 💾 2. ปุ่ม Save (ใช้ Selector เพื่อประสิทธิภาพ)
        Selector<RecordViewmodel, bool>(
          selector: (_, viewModel) => viewModel.isLoading,
          builder: (context, isLoading, child) => CustomButton(
            text: isLoading ? AppStrings.common.saving : "บันทึก",
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
  }

  // -----------------------------------------------------
  // 👁️ View Mode: ปุ่มเมนูดินสอ (แก้ไข/ลบ)
  // -----------------------------------------------------
  Widget _buildViewMenu(RecordViewmodel vm) {
    return Align(
      alignment: Alignment.bottomRight,
      child: CustomPopupMenuButton<String>(
        openAbove: true,
        // ปุ่มดินสอสีเขียว
        icon: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: CustomColor.accentColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [DropShadow.drop_thumb],
          ),
          child: Center(
            // ใช้ Icon หรือ SVG ตามที่มี
            child: Icon(Icons.edit, color: Colors.white),
          ),
        ),
        onOpened: () => setState(() => _isEditMenuOpen = true),
        onCanceled: () => setState(() => _isEditMenuOpen = false),
        onSelected: (action) {
          if (action == 'edit_mode') {
            // ✅ สั่ง VM ให้ปลดล็อก UI เพื่อแก้ไข
            vm.enterEditMode();
          } else if (action == 'delete') {
            // เรียกฟังก์ชันลบ
            vm.deleteRecord();
          }
          setState(() => _isEditMenuOpen = false);
        },
        items: [
          // ✏️ เมนู: แก้ไข
          CustomPopupMenuItem(
            value: 'edit_mode',
            title: 'แก้ไข',
            icon: Icon(Icons.edit, color: CustomColor.accentColor, size: 20),
          ),
          // 🗑️ เมนู: ลบ
          CustomPopupMenuItem(
            value: 'delete',
            title: 'ลบ',
            icon: Icon(Icons.delete_outline, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }
}
