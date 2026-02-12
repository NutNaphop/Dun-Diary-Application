import 'package:dun_diary_app/feature/history/presentation/history_viewmodel.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/button/custom_button.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/sheet/custom_bottom_sheet.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/calendar_sdk.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/models/calendar_types.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryCSVExportSheet extends StatelessWidget {
  final VoidCallback onExport;
  const HistoryCSVExportSheet({super.key, required this.onExport});

  static void show(BuildContext context) {
    final vm = context.read<HistoryViewmodel>();
    vm.resetExportState();

    CustomBottomSheet.show(
      context: context,
      padding: EdgeInsets.zero,
      height: MediaQuery.of(context).size.height * 0.5,
      child: ChangeNotifierProvider.value(
        value: vm,
        child: HistoryCSVExportSheet(onExport: vm.exportToCsv),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryViewmodel>(
      builder: (context, vm, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "ส่งออกข้อมูล csv",
                    fontSize: Dimension.fontSizes.h1,
                    fontWeight: Dimension.fontWeights.bold,
                  ),
                  CustomText(
                    text: "ช่วงเวลา",
                    fontSize: Dimension.fontSizes.md,
                    fontWeight: Dimension.fontWeights.medium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // 📅 เลือกวันเริ่ม
            _buildDateSelector(
              context: context,
              label: "เริ่มจาก",
              dateValue: vm.exportStartDate,
              onTap: () async {
                final date = await showDialog<DateTime>(
                  context: context,
                  builder: (context) {
                    return CalendarSDK(
                      type: CalendarType.month,
                      initialDate: vm.exportStartDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                  },
                );
                if (date != null) vm.setExportStartDate(date);
              },
            ),

            const SizedBox(height: 20),

            // 📅 เลือกวันจบ
            _buildDateSelector(
              context: context,
              label: "จนถึง",
              dateValue: vm.exportEndDate,
              // ถ้ายังไม่เลือกวันเริ่ม ห้ามเลือกวันจบ (กัน User มึน)
              onTap: vm.exportStartDate == null
                  ? null
                  : () async {
                      final date = await showDialog<DateTime>(
                        context: context,
                        builder: (context) {
                          return CalendarSDK(
                            type: CalendarType.month,
                            initialDate: vm.exportEndDate ?? vm.exportStartDate,
                            firstDate:
                                vm.exportStartDate!, // ห้ามย้อนไปก่อนวันเริ่ม
                            lastDate: DateTime.now(),
                          );
                        },
                      );
                      if (date != null) vm.setExportEndDate(date);
                    },
            ),

            const SizedBox(height: 40),
            Divider(color: CustomColor.gray300, thickness: 1),
            const SizedBox(height: 22),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "ยกเลิก",
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: CustomButton(
                      text: "ส่งออก",
                      type: CustomButtonType.fill,
                      backgroundColor: CustomColor.accentColor,
                      onPressed:
                          (vm.exportStartDate == null ||
                              vm.exportEndDate == null)
                          ? null
                          : () {
                              onExport();
                              Navigator.pop(context);
                            },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateSelector({
    required BuildContext context,
    required String label,
    DateTime? dateValue,
    VoidCallback? onTap,
  }) {
    final bool isEnabled = onTap != null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: label, fontSize: 18),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: CustomColor.gray500),
                borderRadius: BorderRadius.circular(8),
                color: isEnabled ? Colors.white : CustomColor.gray100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateValue != null
                        ? DateTimeUtils.formatMonthYear(dateValue)
                        : "เลือกเดือน",
                    style: TextStyle(
                      color: dateValue != null ? Colors.black : Colors.grey,
                    ),
                  ),
                  SVGImage(
                    path: AppIcons.outline.calendar,
                    width: 20,
                    height: 20,
                    color: CustomColor.gray600,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
