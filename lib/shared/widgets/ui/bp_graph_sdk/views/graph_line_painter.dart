import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/models/blood_pressure_graph_models.dart';
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

    final double stepWidth = data.length > 1 
        ? size.width / (data.length - 1) 
        : size.width / 2;
        
    final double stepHeight = size.height / 6;

    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final double x = (data.length == 1) ? stepWidth : i * stepWidth;
      final double y = size.height - ((data[i].level.index + 1)* stepHeight);

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