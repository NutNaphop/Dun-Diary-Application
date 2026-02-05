import 'package:dun_diary_app/data/analyze_record/model/analyze_result_model.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/analyze_card/components/analyze_error_view.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/analyze_card/components/analyze_idle_view.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/analyze_card/components/analyze_process_view.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/analyze_card/components/analyze_success_view.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:flutter/material.dart';

enum AnalyzeState { idle, processing, error, success }

class AnalyzeCard extends StatelessWidget {
  final AnalyzeState state;
  final AnalyzeResultModel? resultFromAi;
  final bool isInternetConnect;
  final VoidCallback? onPressed;

  const AnalyzeCard({
    super.key,
    required this.state,
    required this.resultFromAi,
    this.isInternetConnect = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      content: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (state) {
      case AnalyzeState.idle:
        return AnalyzeIdleView(
          isInternetConnect: isInternetConnect,
          onPressed: onPressed,
        );
      case AnalyzeState.processing:
        return AnalyzeProcessView();
      case AnalyzeState.error:
        return AnalyzeErrorView(
          isInternetConnect: isInternetConnect,
          onPressed: onPressed,
        );
      case AnalyzeState.success:
        // ป้องกันกรณีสถานะเป็น success แต่ไม่มีข้อมูลผลลัพธ์
        if (resultFromAi == null) {
          return AnalyzeIdleView(
            isInternetConnect: isInternetConnect,
            onPressed: onPressed,
          );
        }
        return AnalyzeSuccessView(
          result: resultFromAi,
          isInternetConnect: isInternetConnect,
          onPressed: onPressed,
        );
    }
  }
}
