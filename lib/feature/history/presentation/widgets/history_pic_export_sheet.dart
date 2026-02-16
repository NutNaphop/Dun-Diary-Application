// feature/history/presentation/widgets/history_pic_export_sheet.dart

import 'package:dun_diary_app/feature/history/presentation/history_viewmodel.dart';
import 'package:dun_diary_app/feature/history/presentation/widgets/history_graph_card.dart';
import 'package:dun_diary_app/feature/history/presentation/widgets/history_summary_card.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class HistoryPicExportSheet extends StatelessWidget {
  final DateTime selectedDate;
  final ScreenshotController _screenshotController = ScreenshotController();

  HistoryPicExportSheet({super.key, required this.selectedDate});

  static void show(BuildContext context) {
    final vm = context.read<HistoryViewmodel>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85, // สูง 85% ของจอ
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ChangeNotifierProvider.value(
          value: vm,
          child: HistoryPicExportSheet(selectedDate: vm.selectedDate),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Drag Handle
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: CustomColor.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        // 2. Preview Area
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Screenshot(
              controller: _screenshotController,
              child: _buildPrettyReportLayout(context),
            ),
          ),
        ),

        // 3. Action Buttons Area
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 🅰️ ปุ่ม Save
              _buildActionButton(
                context,
                iconPath: AppIcons
                    .outline
                    .fileDownload, // หรือใช้ Icons.save_alt ถ้าไม่มี SVG
                label: AppStrings.history.recordToDevice,
                onTap: () async {
                  final vm = context.read<HistoryViewmodel>();
                  final image = await _screenshotController.capture(
                    pixelRatio: 3.0,
                  );
                  if (image != null) vm.exportImage(image); // เรียก Save
                },
              ),

              Container(
                width: 1,
                height: 40,
                color: CustomColor.gray300,
              ), // เส้นคั่น
              _buildActionButton(
                context,
                iconPath: AppIcons.outline.share,
                label: AppStrings.common.share,
                onTap: () async {
                  final vm = context.read<HistoryViewmodel>();
                  final image = await _screenshotController.capture(
                    pixelRatio: 3.0,
                  );
                  if (image != null) vm.shareImage(image);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrettyReportLayout(BuildContext context) {
    return Container(
      color: CustomColor.white,
      padding: const EdgeInsets.all(24.0),
      child: AbsorbPointer(
        absorbing: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: AppStrings.history.healthReport,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: CustomColor.gray900,
                    ),
                    CustomText(
                      text: AppStrings.common.appName,
                      fontSize: 14,
                      color: CustomColor.gray500,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: CustomColor.gray900.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomText(
                    text: DateTimeUtils.formatToThaiDate(selectedDate),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: CustomColor.gray900,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),
            Divider(color: Colors.grey.shade300),
            SizedBox(height: 24),

            // Cards Wrapper
            _buildCardWrapper(
              title: AppStrings.history.summarize,
              child: HistorySummaryCard(), // Reuse Widget เดิม
            ),

            SizedBox(height: 24),

            _buildCardWrapper(
              title: AppStrings.history.displayGraph,
              child: HistoryGraphCard(), // Reuse Widget เดิม
            ),

            SizedBox(height: 40),

            // Footer
            Divider(color: Colors.grey.shade300),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: AppStrings.history.signature(AppStrings.common.appName),
                  fontSize: 12,
                  color: CustomColor.gray400,
                ),
                CustomText(
                  text: AppStrings.history.printSince(
                    DateTimeUtils.formatToThaiDate(DateTime.now()),
                  ),
                  fontSize: 12,
                  color: CustomColor.gray400,
                ),
              ],
            ),
            SizedBox(height: 20), // เผื่อพื้นที่ด้านล่าง
          ],
        ),
      ),
    );
  }

  // Helper สร้างกรอบขาว
  Widget _buildCardWrapper({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: CustomText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: CustomColor.gray900,
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: child,
          ),
        ),
      ],
    );
  }

  // Helper ปุ่ม Action
  Widget _buildActionButton(
    BuildContext context, {
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomColor.gray100,
            ),
            child: SVGImage(
              // ใช้ SVG ของคุณ หรือ Icon ถ้าไม่มี
              path: iconPath,
              width: 24,
              height: 24,
              color: CustomColor.gray900,
            ),
          ),
          SizedBox(height: 8),
          CustomText(
            text: label,
            fontSize: Dimension.fontSizes.sm,
            fontWeight: Dimension.fontWeights.medium,
            color: CustomColor.gray600,
          ),
        ],
      ),
    );
  }
}
