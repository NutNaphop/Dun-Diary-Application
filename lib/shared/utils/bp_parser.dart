import 'dart:math' as math;

import 'package:dun_diary_app/data/blood_pressure/model/result_model.dart';

// YOLOBOX Box[0:left, 1:top, 2:right, 3:bottom]

class BPParser {
  static List<BPFormat> parse(List<YoloV8Response> detections) {
    // 1. Filter "10" out 
    List<YoloV8Response> rawDigits = detections
        .where((d) => d.label != "10")
        .toList();

    if (rawDigits.isEmpty) return [];

    // --- STEP 1: Noise Filter ---
    // Find Median Height
    rawDigits.sort(
      (a, b) => (a.box[3] - a.box[1]).compareTo(b.box[3] - b.box[1]),
    );

    double medianHeight =
        rawDigits[rawDigits.length ~/ 2].box[3] -
        rawDigits[rawDigits.length ~/ 2].box[1];

    List<YoloV8Response> digits = rawDigits.where((d) {
      double h = d.box[3] - d.box[1];
      double w = d.box[2] - d.box[0];

      // Rule 1: ความสูงต้องไม่น้อยกว่า 50% ของ Median Height
      if (h < medianHeight * 0.5) return false;

      // Rule 2: ต้องไม่กว้างเกิน 2.5 เท่าของความสูง
      if (w > h * 2.5) return false;

      return true;
    }).toList();

    if (digits.isEmpty) return [];

    // --- STEP 2: Geometric Zoning ---
    // หาขอบบนสุด และ ล่างสุด ของกลุ่มตัวเลข
    double minY = digits.map((e) => _getCenterY(e)).reduce(math.min);
    double maxY = digits.map((e) => _getCenterY(e)).reduce(math.max);

    // ความสูงรวมของพื้นที่ตัวเลข
    double totalSpan = maxY - minY;

    // ถ้ามีตัวเลขแค่บรรทัดเดียว หรือน้อยมาก ให้ถือเป็น SYS ไว้ก่อน
    if (totalSpan < medianHeight) {
      return [
        BPFormat(
          bpType: BPType.SYS,
          item: BPItem(posX: 0, posY: 0, value: _joinDigits(digits)),
        ),
        BPFormat(
          bpType: BPType.DIA,
          item: BPItem(posX: 0, posY: 0, value: ""),
        ),
        BPFormat(
          bpType: BPType.PUL,
          item: BPItem(posX: 0, posY: 0, value: ""),
        ),
      ];
    }

    List<YoloV8Response> sysList = [];
    List<YoloV8Response> diaList = [];
    List<YoloV8Response> pulList = [];

    // จุดตัดแบ่งโซน (Cutoff Points)
    // Zone 1 (SYS) 35%
    double cut1 = minY + (totalSpan * 0.35);
    // Zone 2 (DIA) 70%
    double cut2 = minY + (totalSpan * 0.70);

    for (var d in digits) {
      double y = _getCenterY(d);
      if (y <= cut1) {
        sysList.add(d);
      } else if (y <= cut2) {
        diaList.add(d);
      } else {
        pulList.add(d);
      }
    }

    // --- STEP 3: Map Result ---
    return [
      BPFormat(
        bpType: BPType.SYS,
        item: BPItem(posX: 0, posY: 0, value: _joinDigits(sysList)),
      ),
      BPFormat(
        bpType: BPType.DIA,
        item: BPItem(posX: 0, posY: 0, value: _joinDigits(diaList)),
      ),
      BPFormat(
        bpType: BPType.PUL,
        item: BPItem(posX: 0, posY: 0, value: _joinDigits(pulList)),
      ),
    ];
  }

  static double _getCenterY(YoloV8Response d) =>
      d.box[1] + (d.box[3] - d.box[1]) / 2;
      
  static List<YoloV8Response> mapToYoloBoxResponse(
    List<Map<String, dynamic>> detections,
  ) {
    return detections.map((e) {
      final box = List<double>.from(e["box"]);
      return YoloV8Response(
        classId: e['tag'] ?? "No Found",
        label: e['tag'],
        score: box.length > 4 ? box[4] : 0.0,
        box: box,
      );
    }).toList();
  }

  static String _joinDigits(List<YoloV8Response> digits) {
    if (digits.isEmpty) return "";

    digits.sort((a, b) => a.box[0].compareTo(b.box[0]));

    return digits.map((e) => e.label).join("");
  }

  static String getValueByType(List<BPFormat> result, BPType type) {
    if (result.isEmpty) return "-";
    final found = result.firstWhere(
      (e) => e.bpType == type,
      orElse: () => BPFormat(
        bpType: type,
        item: BPItem(posX: 0, posY: 0, value: ""),
      ),
    );
    return found.item.value.isNotEmpty ? found.item.value : "-";
  }
}
