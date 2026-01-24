import 'package:dun_diary_app/shared/constant/app_image.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/no_content_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/models/blood_pressure_graph_models.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/utils/graph_config.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/utils/graph_utils.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/views/graph_grid_painter.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/views/graph_line_painter.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';

import 'package:flutter/material.dart';

class BpGraphSdk extends StatelessWidget {
  final List<BloodPressureGraphData> data;
  final Function(BloodPressureGraphData)? onPointTap;

  const BpGraphSdk({super.key, required this.data, this.onPointTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        // Config
        const yLabelWidth = GraphConfig.yLabelWidth;
        const xLabelHeight = GraphConfig.xLabelWidth;

        final graphWidth = maxWidth - yLabelWidth;
        final graphHeight = maxHeight - xLabelHeight;

        final stepHeight = GraphUtils.getStepHeight(graphHeight);
        final stepWidth = GraphUtils.getStepWidth(graphWidth, data.length);

        return SizedBox(
          width: maxWidth,
          height: maxHeight,
          child: data.isEmpty
              ? NoContentCard(
                title: AppStrings.bpGraphSdk.noHaveData,
                subtitle: AppStrings.bpGraphSdk.recordToSeeTrend,
                imagePath: AppImage.noMatchFound,
                imageSize: 110,
              )
              : Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // 1. Grid & Lines
                    Positioned(
                      top: 0,
                      left: 0,
                      width: graphWidth,
                      height: graphHeight,
                      child: CustomPaint(
                        painter: GraphGridPainter(),
                        foregroundPainter: data.isNotEmpty
                            ? GraphLinePainter(data, CustomColor.gray200)
                            : null,
                      ),
                    ),

                    // 2. Y-Axis Labels
                    for (int i = 0; i < 5; i++)
                      Positioned(
                        right: 0,
                        top:
                            GraphUtils.getYCoordinate(
                              i,
                              graphHeight,
                              stepHeight,
                            ) -
                            10,
                        width: yLabelWidth,
                        child: CustomText(
                          text: BloodPressureLevel.values[i].label,
                          fontSize: Dimension.fontSizes.rg,
                          fontWeight: Dimension.fontWeights.regular,
                          color: CustomColor.gray600,
                          textAlign: TextAlign.right,
                        ),
                      ),

                    // 3. X-Axis Labels
                    if (data.isNotEmpty)
                      for (int i = 0; i < data.length; i++)
                        Positioned(
                          left:
                              GraphUtils.getXCoordinate(
                                i,
                                data.length,
                                stepWidth,
                              ) -
                              GraphConfig.yLabelWidthHalf,
                          top: graphHeight + 8,
                          width: yLabelWidth,
                          child: CustomText(
                            text: data[i].xLabel,
                            fontSize: Dimension.fontSizes.esm,
                            fontWeight: Dimension.fontWeights.regular,
                            color: CustomColor.gray500,
                            textAlign: TextAlign.center,
                          ),
                        ),

                    // 4. Interactive Dots
                    if (data.isNotEmpty)
                      for (int i = 0; i < data.length; i++) ...[
                        Positioned(
                          left:
                              GraphUtils.getXCoordinate(
                                i,
                                data.length,
                                stepWidth,
                              ) -
                              GraphConfig
                                  .halfPointSize, // minus with half of size
                          top:
                              GraphUtils.getYCoordinate(
                                data[i].level.index,
                                graphHeight,
                                stepHeight,
                              ) -
                              GraphConfig.halfPointSize,
                          child: GestureDetector(
                            onTap: () => onPointTap?.call(data[i]),
                            child: Container(
                              width: GraphConfig.pointSize,
                              height: GraphConfig.pointSize,
                              decoration: BoxDecoration(
                                color: data[i].level.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                  ],
                ),
        );
      },
    );
  }
}
