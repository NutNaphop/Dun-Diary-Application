import 'package:dun_diary_app/shared/style/color.dart';
import 'package:flutter/material.dart';

class GraphGridPainter extends CustomPainter {
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final stepHeight = size.height / 6;
    paint.color = CustomColor.gray200;
    paint.strokeWidth = 1;

    for (int i = 0; i <= 6; i++) {
      final y = size.height - (i * stepHeight);
      final p1 = Offset(0, y);
      final p2 = Offset(size.width, y);

      if (i == 0){
        paint.color = CustomColor.gray400;
        paint.strokeWidth = 1.0; 
        canvas.drawLine(p1, p2, paint);
      } else if (i == 6){
        paint.color = CustomColor.gray200;
        paint.strokeWidth = 1.0;
        canvas.drawLine(p1, p2, paint);
      } else{
        paint.color = CustomColor.gray200;
        paint.strokeWidth = 1.0;
        _drawDashedLine(canvas, paint, p1, p2);
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset p1, Offset p2) {
    const dashWidth = 5.0;
    const dashSpace = 5.0;
    double startX = p1.dx;
    
    while (startX < p2.dx) {
      canvas.drawLine(
        Offset(startX, p1.dy),
        Offset(startX + dashWidth, p1.dy),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }
}
