import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/utils/graph_config.dart';
import 'package:flutter/material.dart';

/// Custom Painter สำหรับวาดเส้น Grid ของกราฟ
///
/// วาด 7 เส้นแนวนอน:
/// - เส้นที่ 0 (baseline): เส้นทึบสีเข้ม
/// - เส้นที่ 1-5: เส้นประ (dashed lines)
/// - เส้นที่ 6: เส้นทึบสีอ่อน (top line)
class GraphGridPainter extends CustomPainter {
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // 8 เส้น (0-7) แบ่งเป็น 7 ช่วง
    final stepHeight = size.height / (GraphConfig.amountOfLine - 1);

    for (int i = 0; i < GraphConfig.amountOfLine.toInt(); i++) {
      final y = size.height - (i * stepHeight);
      final p1 = Offset(0, y);
      final p2 = Offset(size.width, y);

      if (i == 0 || i == 7) {
        // Line 0 (bottom) และ Line 7 (top) = solid baseline
        paint.color = CustomColor.gray400;
        paint.strokeWidth = 1.0;
        canvas.drawLine(p1, p2, paint);
      } else {
        // Lines 1-6 = dashed (6 levels: ต่ำ ปกติ สูง สูงระดับ1 สูงระดับ2 วิกฤต)
        paint.color = CustomColor.gray200;
        paint.strokeWidth = 1.0;
        _drawDashedLine(canvas, paint, p1, p2);
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset p1, Offset p2) {
    double startX = p1.dx;

    while (startX < p2.dx) {
      canvas.drawLine(
        Offset(startX, p1.dy),
        Offset(startX + GraphConfig.dashWidth, p1.dy),
        paint,
      );
      startX += GraphConfig.dashWidth + GraphConfig.dashSpace;
    }
  }
}
