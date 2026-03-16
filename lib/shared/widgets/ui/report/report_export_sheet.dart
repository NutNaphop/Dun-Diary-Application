import 'dart:typed_data';

import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

/// Shared Report Export Sheet — generic bottom sheet for exporting
/// a report as an image. Each screen provides its own content widget.
class ReportExportSheet extends StatelessWidget {
  final DateTime selectedDate;
  final Widget content;
  final Future<void> Function(Uint8List imageBytes) onExportImage;
  final Future<void> Function(Uint8List imageBytes) onShareImage;
  final ScreenshotController _screenshotController = ScreenshotController();

  ReportExportSheet({
    super.key,
    required this.selectedDate,
    required this.content,
    required this.onExportImage,
    required this.onShareImage,
  });

  /// Show the report export sheet as a modal bottom sheet.
  static void show(
    BuildContext context, {
    required DateTime selectedDate,
    required Widget content,
    required Future<void> Function(Uint8List imageBytes) onExportImage,
    required Future<void> Function(Uint8List imageBytes) onShareImage,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ReportExportSheet(
          selectedDate: selectedDate,
          content: content,
          onExportImage: onExportImage,
          onShareImage: onShareImage,
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
              child: _buildReportLayout(context),
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
              _buildActionButton(
                context,
                iconPath: AppIcons.outline.fileDownload,
                label: AppStrings.history.recordToDevice,
                onTap: () async {
                  final image = await _screenshotController.capture(
                    pixelRatio: 3.0,
                  );
                  if (image != null) await onExportImage(image);
                },
              ),
              Container(width: 1, height: 40, color: CustomColor.gray300),
              _buildActionButton(
                context,
                iconPath: AppIcons.outline.share,
                label: AppStrings.common.share,
                onTap: () async {
                  final image = await _screenshotController.capture(
                    pixelRatio: 3.0,
                  );
                  if (image != null) await onShareImage(image);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportLayout(BuildContext context) {
    return Container(
      color: CustomColor.white,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: AbsorbPointer(
        absorbing: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: AppStrings.common.appName,
                  fontSize: Dimension.fontSizes.lg,
                  fontWeight: Dimension.fontWeights.bold,
                  color: CustomColor.gray900,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: CustomText(
                    text: DateTimeUtils.formatToThaiDate(selectedDate),
                    fontSize: Dimension.fontSizes.rg,
                    color: CustomColor.gray900,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Content — provided by caller
            content,

            SizedBox(height: 16),

            // Footer
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
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  /// Helper: card wrapper with shadow border
  static Widget buildCardWrapper({required Widget child}) {
    return child;
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColor.gray100,
                ),
                child: SVGImage(
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
        ),
      ),
    );
  }
}
