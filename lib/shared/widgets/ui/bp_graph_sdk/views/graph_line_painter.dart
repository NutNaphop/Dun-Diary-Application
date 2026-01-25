import 'dart:ui';

import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/models/blood_pressure_graph_models.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/utils/graph_utils.dart';
import 'package:flutter/material.dart';

class GraphLinePainter extends CustomPainter {
  final List<BloodPressureGraphData> data;
  final Color lineColor;
  final double progress;

  GraphLinePainter(this.data, this.lineColor, {this.progress = 1.0});

  @override
  bool shouldRepaint(covariant GraphLinePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.data != data;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final double stepWidth = GraphUtils.getStepWidth(size.width, data.length);
    final double stepHeight = GraphUtils.getStepHeight(size.height);

    final path = Path();
    
    for (int i = 0; i < data.length; i++) {
      final double x = GraphUtils.getXCoordinate(i, data.length, stepWidth);
      final double y = GraphUtils.getYCoordinate(
        data[i].level.index,
        size.height,
        stepHeight,
      );

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Animation draw
    if (data.length > 1) {
      PathMetrics pathMetrics = path.computeMetrics();
      for (PathMetric pathMetric in pathMetrics) {
        double extractLength = pathMetric.length * progress;
        Path extractedPath = pathMetric.extractPath(0, extractLength);
        canvas.drawPath(extractedPath, paint);
      }
    }
  }
}
