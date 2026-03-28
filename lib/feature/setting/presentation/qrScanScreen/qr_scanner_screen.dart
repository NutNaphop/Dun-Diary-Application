import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _isScanned = false;
  final MobileScannerController _controller = MobileScannerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      usePadding: false,
      appBar: MainAppBar(
        title: "สแกน QR Code",
        showBack: true,
        onBackPressed: () => NavigationService.instance.goBack(),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double scanAreaSize = constraints.maxWidth * 0.7;
          final Rect scanWindow = Rect.fromCenter(
            center: Offset(
              constraints.maxWidth / 2,
              (constraints.maxHeight / 2) - 60, // ขยับขึ้น 60 พิกเซล
            ),
            width: scanAreaSize,
            height: scanAreaSize,
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              MobileScanner(
                controller: _controller,
                scanWindow: scanWindow,
                onDetect: (capture) {
                  if (_isScanned) return;
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                    _isScanned = true;
                    NavigationService.instance.goBack(
                      result: barcodes.first.rawValue,
                    );
                  }
                },
              ),
              CustomPaint(
                painter: ScannerOverlayPainter(scanWindow: scanWindow),
              ),
              Positioned(
                bottom: (constraints.maxHeight / 2) - (scanAreaSize / 2),
                left: 0,
                right: 0,
                child: const Center(
                  child: Text(
                    "จัด QR Code ให้อยู่ในกรอบ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Rect scanWindow;
  final double borderRadius;

  ScannerOverlayPainter({required this.scanWindow, this.borderRadius = 16.0});

  @override
  void paint(Canvas canvas, Size size) {
    // วาดพื้นหลังสีดำโปร่งแสง
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // วาดกรอบสี่เหลี่ยมที่จะเจาะรู
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(scanWindow, Radius.circular(borderRadius)),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    // รวม Path และเจาะรูด้วย PathOperation.difference
    final basePath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(basePath, backgroundPaint);

    // วาดเส้นขอบสีขาวรอบๆ บริเวณสแกน
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(scanWindow, Radius.circular(borderRadius)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}
