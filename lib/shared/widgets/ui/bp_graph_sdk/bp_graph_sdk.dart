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

class BpGraphSdk extends StatefulWidget {
  final List<BloodPressureGraphData> data;
  final Function(BloodPressureGraphData)? onPointTap;

  const BpGraphSdk({super.key, required this.data, this.onPointTap});

  @override
  State<BpGraphSdk> createState() => _BpGraphSdkState();
}

class _BpGraphSdkState extends State<BpGraphSdk>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    _animationController.forward(); // สั่งให้เริ่มเล่น
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
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
            final stepWidth = GraphUtils.getStepWidth(
              graphWidth,
              widget.data.length,
            );

            return SizedBox(
              width: maxWidth,
              height: maxHeight,
              child: widget.data.isEmpty
                  ? NoContentCard(
                      title: AppStrings.bpGraphSdk.noHaveData,
                      subtitle: AppStrings.bpGraphSdk.recordToSeeTrend,
                      imagePath: AppImage.noMatchFound,
                      imageWidth: 110,
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
                            foregroundPainter: widget.data.isNotEmpty
                                ? GraphLinePainter(
                                    widget.data,
                                    CustomColor.gray200,
                                    progress: _animation.value,
                                  )
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
                        if (widget.data.isNotEmpty)
                          for (int i = 0; i < widget.data.length; i++)
                            Positioned(
                              left:
                                  GraphUtils.getXCoordinate(
                                    i,
                                    widget.data.length,
                                    stepWidth,
                                  ) -
                                  GraphConfig.yLabelWidthHalf,
                              top: graphHeight + 8,
                              width: yLabelWidth,
                              child: CustomText(
                                text: widget.data[i].xLabel,
                                fontSize: Dimension.fontSizes.esm,
                                fontWeight: Dimension.fontWeights.regular,
                                color: CustomColor.gray500,
                                textAlign: TextAlign.center,
                              ),
                            ),

                        // 4. Interactive Dots
                        if (widget.data.isNotEmpty)
                          ...widget.data.asMap().entries.map((entry) {
                            final i = entry.key; // ดึง index
                            final item = entry.value; // ดึงข้อมูล (data[i])
                            double dotThreshold = 0.0;

                            if (widget.data.length > 1) {
                              dotThreshold = i / (widget.data.length);

                              double scale = 0.0;

                              if (_animation.value >= dotThreshold) {
                                // entryProgress: ค่า 0.0 -> 1.0 สำหรับจุดนี้โดยเฉพาะ
                                // คูณ widget.data.length เพื่อให้จุดมันเด้งขึ้นมาเร็วๆ ไม่ได้ค่อยๆ ใหญ่พร้อมกันทั้งเส้น
                                double entryProgress =
                                    (_animation.value - dotThreshold) *
                                    widget.data.length;

                                // บีบค่าให้อยู่ในช่วง 0-1
                                double clampedProgress = entryProgress.clamp(
                                  0.0,
                                  1.0,
                                );

                                // ใส่ Effect เด้งดึ๋ง (Elastic)
                                scale = Curves.elasticOut.transform(
                                  clampedProgress,
                                );

                                return Positioned(
                                  left:
                                      GraphUtils.getXCoordinate(
                                        i,
                                        widget.data.length,
                                        stepWidth,
                                      ) -
                                      GraphConfig
                                          .halfPointSize, // minus with half of size
                                  top:
                                      GraphUtils.getYCoordinate(
                                        item.level.index,
                                        graphHeight,
                                        stepHeight,
                                      ) -
                                      GraphConfig.halfPointSize,
                                  child: Transform.scale(
                                    scale: scale,
                                    child: GestureDetector(
                                      onTap: () =>
                                          widget.onPointTap?.call(item),
                                      child: Container(
                                        width: GraphConfig.pointSize,
                                        height: GraphConfig.pointSize,
                                        decoration: BoxDecoration(
                                          color: item.level.color,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }

                            // Return an empty widget when this entry shouldn't render yet
                            return const SizedBox.shrink();
                          }).toList(),
                      ],
                    ),
            );
          },
        );
      },
    );
  }
}
