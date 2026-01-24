import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/models/blood_pressure_graph_models.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/utils/graph_utils.dart';
import 'package:flutter/material.dart';

class GraphLinePainter extends CustomPainter {
  final List<BloodPressureGraphData> data;
  final Color lineColor;

  GraphLinePainter(this.data, this.lineColor);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final double stepWidth = GraphUtils.getStepWidth(size.width, data.length);
    final double stepHeight = GraphUtils.getStepHeight(size.height);

    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final double x = GraphUtils.getXCoordinate(i, data.length, stepWidth);
      final double y = GraphUtils.getYCoordinate(data[i].level.index, size.height, stepHeight);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    if (data.length > 1) {
      canvas.drawPath(path, paint);
    }
  }
}