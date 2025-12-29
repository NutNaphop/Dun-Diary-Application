import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_box_icon.dart';
import 'package:dun_diary_app/feature/record/presentation/record_viewModel.dart';
import 'package:dun_diary_app/feature/record/presentation/widgets/bp_card/bp_card_layout.dart';
import 'package:dun_diary_app/feature/record/presentation/widgets/demo/demo_record.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
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
import 'package:provider/provider.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => RecordViewmodel(),
      child: const RecordScreen(),
    );
  }

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  bool _isMenuOpen = false;
  late int _selectVal ; 
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RecordViewmodel>();

    return CustomScaffold(
      appBar: MainAppBar(
        title: "บันทึกความดัน",
        showBack: true,
        backIconPath: AppIcons.outline.x,
        onBackPressed: () => NavigationService.instance.goBack(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 36),
        child: Column(
          children: [
            CustomCard(
              content: BpCardLayout(
                sys: viewModel.bpValue.sys,
                dia: viewModel.bpValue.dia,
                pul: viewModel.bpValue.pul,
                onSysChanged: (val) => viewModel.updateSys(val),
                onDiaChanged: (val) => viewModel.updateDia(val),
                onPulChanged: (val) => viewModel.updatePul(val),
              ),
            ),

            const SizedBox(height: 20),

            CustomCard(
              title: BloodPressureUtils.mapLevelLabel(viewModel.level),
              titleFontSize: 21,
              titleTextAlign: TextAlign.center,
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              content: BloodPressureGauge(
                level: viewModel.level,
                avgLevel: viewModel.avgLevel,
              ),
            ),

            const SizedBox(height: 25),

            // Date time picker
            Row(
              children: [
                Expanded(
                  child: DatePicker(
                    selectedDate: viewModel.recordDate,
                    onDateTimeChanged: (val) => viewModel.setRecordDate(val),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TimePicker(
                    selectedDate: viewModel.recordDate,
                    onDateTimeChanged: (val) => viewModel.setRecordDate(val),
                  ),
                ),
              ],
            ),
            DemoRecord(
              currentAvgLevel: viewModel.avgLevel,
              onBPValset: (val) => viewModel.setBPValue(val),
              onAVGValset: (val) => viewModel.setAvgLevel(val),
            ),
            Spacer(),
            Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomPopupMenuButton(
                  openAbove: true, 
                  icon: CustomBoxIcon(
                    iconPath: AppIcons.outline.camera,
                    activeIconPath: AppIcons.outline.x,
                    isActive: _isMenuOpen,
                  ),
                  onOpened: () => setState(() => _isMenuOpen = true),
                  onCanceled: () => setState(() => _isMenuOpen = false),
                  onSelected: (String result) {
                    print(result);
                    
                    setState(() { _isMenuOpen = false; _selectVal = int.parse(result);}); // เลือกเมนู -> คืนรูป
                  },
                  items: [
                    CustomPopupMenuItem(
                      value: "0",
                      title: 'ถ่ายรูปผลวัด',
                      icon: SVGImage(
                        path: AppIcons.duotone.camera,
                        size: 22,
                        color: CustomColor.accentColor,
                      ),
                    ),
                    CustomPopupMenuItem(
                      value: "1",
                      title: 'เลือกรูปจากคลัง',
                      icon: SVGImage(path: AppIcons.duotone.image, size: 22, color: CustomColor.accentColor),
                    ),
                  ],
                ),
                CustomButton(
                  text: "บันทึก",
                  type: CustomButtonType.fill,
                  backgroundColor: CustomColor.accentColor,
                  onPressed: () => {print("Record Click: $_selectVal")},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
