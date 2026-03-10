import 'package:dun_diary_app/feature/history/presentation/history_viewmodel.dart';
import 'package:dun_diary_app/feature/history/presentation/widgets/history_graph_card.dart';
import 'package:dun_diary_app/feature/history/presentation/widgets/history_summary_card.dart';
import 'package:dun_diary_app/shared/widgets/ui/report/report_export_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// History-specific wrapper that provides content + callbacks
/// to the shared [ReportExportSheet].
class HistoryPicExportSheet {
  HistoryPicExportSheet._();

  static void show(BuildContext context) {
    final vm = context.read<HistoryViewmodel>();

    final content = ChangeNotifierProvider.value(
      value: vm,
      child: Column(
        children: [
          ReportExportSheet.buildCardWrapper(
            child: HistorySummaryCard(compact: true),
          ),
          SizedBox(height: 10),
          ReportExportSheet.buildCardWrapper(
            child: HistoryGraphCard(
              graphHeight: 250,
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );

    ReportExportSheet.show(
      context,
      selectedDate: vm.selectedDate,
      content: content,
      onExportImage: (imageBytes) => vm.exportImage(imageBytes),
      onShareImage: (imageBytes) => vm.shareImage(imageBytes),
    );
  }
}
