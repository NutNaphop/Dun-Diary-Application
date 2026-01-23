import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/models/blood_pressure_graph_models.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/views/graph_line_painter.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/views/graph_grid_painter.dart';
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
        const yLabelWidth = 40.0;
        const xLabelHeight = 20.0;

        // พื้นที่กราฟจริง (หักขอบขวาและล่างออก)
        final graphWidth = maxWidth - yLabelWidth;
        final graphHeight = maxHeight - xLabelHeight;

        final stepHeight = graphHeight / 6;
        final stepWidth = data.length > 1
            ? graphWidth / (data.length - 1)
            : graphWidth / 2;

        return SizedBox(
          width: maxWidth,
          height: maxHeight,
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
                  foregroundPainter: data.isNotEmpty
                      ? GraphLinePainter(data, CustomColor.gray200)
                      : null,
                ),
              ),
          
              // 2. Y-Axis Labels
              for (int i = 0; i < 5; i++)
                Positioned(
                  right: 0,
                  top: (graphHeight - ((i + 1) * stepHeight)) - 10,
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
                    left: ((data.length == 1 ? stepWidth : i * stepWidth)) - 20,
                    top: graphHeight + 8,
                    width: 40,
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
                        ((data.length == 1 ? stepWidth : i * stepWidth)) -
                        4, // minus with half of size
                    top:
                        (graphHeight - ((data[i].level.index + 1) * stepHeight)) -
                        4,
                    child: GestureDetector(
                      onTap: () => onPointTap?.call(data[i]),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: data[i].level.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
          
              if (data.isEmpty)
                Positioned.fill(child: Center(child: Text("No have data"))),
            ],
          ),
        );
      },
    );
  }
}
