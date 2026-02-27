import 'package:dun_diary_app/data/analyze_record/model/analyze_result_model.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/analyze_card/components/analyze_error_view.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/analyze_card/components/analyze_idle_view.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/analyze_card/components/analyze_no_data_view.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/analyze_card/components/analyze_process_view.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/analyze_card/components/analyze_success_view.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

enum AnalyzeState { idle, processing, error, success, noData }

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
    return Column(
      children: [
        CustomCard(
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          content: _buildContent(),
        ),
        SizedBox(height: resultFromAi != null ? 15 : 0),
        resultFromAi != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SVGImage(
                    path: AppIcons.duotone.dangerTriangle,
                    width: 15,
                    height: 15,
                    color: CustomColor.gray900,
                  ),
                  SizedBox(width: 5),
                  CustomText(
                    text:
                        "AI วิเคราะห์เบื้องต้น ไม่สามารถแทนการวินิจฉัยของแพทย์ได้",
                    fontSize: Dimension.fontSizes.rg,
                    fontWeight: Dimension.fontWeights.regular,
                    color: CustomColor.gray500,
                  ),
                ],
              )
            : SizedBox.shrink(),
      ],
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
      case AnalyzeState.noData:
        return const AnalyzeNoDataView();
    }
  }
}
