import 'package:dun_diary_app/core/services/export_service.dart';
import 'package:dun_diary_app/core/services/flushbar_service.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/feature/stat/presentation/stat_viewModel.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/views/stat_summary_view.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/widgets/ui/report/report_export_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Stat-specific wrapper that provides content + callbacks
/// to the shared [ReportExportSheet].
///
/// Reuses [StatSummaryView] with `compact: true` to avoid
/// duplicating widget code.
class StatPicExportSheet {
  StatPicExportSheet._();

  static void show(BuildContext context) {
    final vm = context.read<StatViewmodel>();

    final content = StatSummaryView(
      compact: true,
      dateLabel: vm.currentRangeLabel,
      analyzeState: vm.analyzeState,
      resultFromAi: vm.aiResultContent,
      data: vm.statsData,
      bloodPressureLevel: vm.bloodPressureLevel,
      graphData: vm.graphData,
      onAnalyzePressed: null,
      onRecordPressed: null,
    );

    ReportExportSheet.show(
      context,
      selectedDate: vm.focusedDate,
      content: content,
      onExportImage: (imageBytes) async {
        try {
          await ExportService.instance.saveToGallery(imageBytes);
          FlushbarService.instance.showSuccess(
            AppStrings.history.saveImageSuccess,
          );
        } catch (e) {
          FlushbarService.instance.showError(AppStrings.history.saveImageError);
        } finally {
          NavigationService.instance.goBack();
        }
      },
      onShareImage: (imageBytes) async {
        try {
          await ExportService.instance.shareImage(imageBytes);
        } catch (e) {
          FlushbarService.instance.showError(
            AppStrings.history.shareImageError,
          );
        }
      },
    );
  }
}
