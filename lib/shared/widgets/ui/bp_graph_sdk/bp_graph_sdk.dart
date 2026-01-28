import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/models/blood_pressure_graph_models.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/utils/graph_config.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/utils/graph_utils.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/views/graph_grid_painter.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/views/graph_line_painter.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/views/no_data_layout.dart';
import 'package:flutter/material.dart';

class BpGraphSdk extends StatefulWidget {
  final String? heading;
  final List<BloodPressureGraphData> data;
  final Function(BloodPressureGraphData)? onPointTap;
  final VoidCallback? onButtonPress;

  const BpGraphSdk({
    super.key,
    this.heading,
    required this.data,
    this.onPointTap,
    this.onButtonPress,
  });

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
    final headingDisplayText = widget.heading ?? "";
    final bool isNoData = widget.data.isEmpty;
    final List<BloodPressureGraphData> renderData = isNoData
        ? _getMockData()
        : widget.data;

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
              renderData.length,
            );

            return SizedBox(
              width: maxWidth,
              height: maxHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // ครอบส่วนประกอบของกราฟทั้งหมดด้วย Opacity
                  Positioned.fill(
                    child: Opacity(
                      opacity: isNoData ? 0.25 : 1.0,
                      child: Stack(
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
                              foregroundPainter: GraphLinePainter(
                                renderData,
                                CustomColor.gray200,
                                progress: _animation.value,
                              ),
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
                          if (!isNoData)
                            for (int i = 0; i < renderData.length; i++)
                              Positioned(
                                left:
                                    GraphUtils.getXCoordinate(
                                      i,
                                      renderData.length,
                                      stepWidth,
                                    ) -
                                    GraphConfig.yLabelWidthHalf,
                                top: graphHeight + 8,
                                width: yLabelWidth,
                                child: CustomText(
                                  text: renderData[i].xLabel,
                                  fontSize: Dimension.fontSizes.esm,
                                  fontWeight: Dimension.fontWeights.regular,
                                  color: CustomColor.gray500,
                                  textAlign: TextAlign.center,
                                ),
                              ),

                          // 4. Interactive Dots
                          if (renderData.isNotEmpty)
                            ...renderData.asMap().entries.map((entry) {
                              final i = entry.key;
                              final item = entry.value;
                              double dotThreshold = 0.0;

                              if (renderData.length > 1) {
                                dotThreshold = i / (renderData.length);
                                double scale = 0.0;

                                if (_animation.value >= dotThreshold) {
                                  double entryProgress =
                                      (_animation.value - dotThreshold) *
                                      renderData.length;
                                  double clampedProgress = entryProgress.clamp(
                                    0.0,
                                    1.0,
                                  );
                                  scale = Curves.elasticOut.transform(
                                    clampedProgress,
                                  );

                                  return Positioned(
                                    left:
                                        GraphUtils.getXCoordinate(
                                          i,
                                          renderData.length,
                                          stepWidth,
                                        ) -
                                        GraphConfig.halfPointSize,
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
                                        onTap: isNoData
                                            ? null
                                            : () =>
                                                  widget.onPointTap?.call(item),
                                        child: Container(
                                          width: GraphConfig.pointSize,
                                          height: GraphConfig.pointSize,
                                          decoration: BoxDecoration(
                                            color: isNoData
                                                ? CustomColor.gray300
                                                : item.level.color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                              return const SizedBox.shrink();
                            }).toList(),
                        ],
                      ),
                    ),
                  ),

                  if (isNoData)
                    NoDataLayout(
                      heading: headingDisplayText,
                      onButtonPress: widget.onButtonPress,
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

List<BloodPressureGraphData> _getMockData() {
  return List.generate(7, (index) {
    final levels = [
      BloodPressureLevel.normal,
      BloodPressureLevel.preHigh,
      BloodPressureLevel.normal,
      BloodPressureLevel.preHigh,
      BloodPressureLevel.normal,
      BloodPressureLevel.preHigh,
      BloodPressureLevel.normal,
    ];
    return BloodPressureGraphData(
      xLabel: '',
      level: levels[index % levels.length],
      sourceData: 'mock',
    );
  });
}
