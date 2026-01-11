import 'package:dun_diary_app/data/blood_pressure/model/result_model.dart';

class BPParser {
  
  /// ฟังก์ชันหลักสำหรับแปลงค่าจาก YOLO -> BPFormat
  /// คืนค่าเป็น List ว่าง [] ถ้าอ่านค่าไม่สำเร็จ
  static List<BPFormat> parse(List<YoloV8Response> detections) {
    // 1. เตรียมโครงสร้างข้อมูลผลลัพธ์
    final result = [
      BPFormat(bpType: BPType.SYS, item: BPItem(posX: 0, posY: 0, value: '')),
      BPFormat(bpType: BPType.DIA, item: BPItem(posX: 0, posY: 0, value: '')),
      BPFormat(bpType: BPType.PUL, item: BPItem(posX: 0, posY: 0, value: ''))
    ];

    try {
      // 2. หาตำแหน่ง Marker (เส้นบรรทัด) ที่ Label == "10"
      final markers = _findMarkers(detections);
      
      // Safety Check: ถ้าเจอ Marker ไม่ครบ 3 อัน (SYS, DIA, PUL) แสดงว่าอ่านผิด
      if (markers.length < 3) {
        print("⚠️ BPParser Error: Detected only ${markers.length} markers (Expected 3).");
        return []; 
      }

      // 3. อัปเดตตำแหน่งแกน Y อ้างอิงให้กับ result แต่ละตัว
      for (int i = 0; i < 3; i++) {
        result[i].item.posX = markers[i][0]; // X
        result[i].item.posY = markers[i][1]; // Y
      }

      // 4. เอาตัวเลขที่อ่านได้ (ที่ไม่ใช่ Marker) มาหยอดใส่ช่อง
      return _mapDigitsToZones(detections, result);

    } catch (e, stackTrace) {
      print("❌ BPParser Exception: $e");
      print(stackTrace);
      return []; // คืนค่าว่างดีกว่าทำแอปเด้ง
    }
  }

  static List<YoloV8Response> mapToYoloBoxResponse(List<Map<String,dynamic>> detections) {
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

  /// หาตำแหน่งของ Marker (Label "10") และเรียงจากบนลงล่าง
  static List<List<double>> _findMarkers(List<YoloV8Response> detections) {
    // กรองเอาเฉพาะตัวที่เป็น Marker "10"
    final markerObjects = detections.where((d) => d.label == "10").toList();

    // ดึงเฉพาะพิกัด [x, y] ออกมา (สมมติว่า box[0]=x, box[1]=y)
    List<List<double>> coordinates = markerObjects.map((item) {
      return [item.box[0].toDouble(), item.box[1].toDouble()]; 
    }).toList();

    // เรียงตามแกน Y (บน -> ล่าง)
    coordinates.sort((a, b) => a[1].compareTo(b[1]));

    return coordinates;
  }

  /// จัดกลุ่มตัวเลขเข้าสู่โซน SYS, DIA, PUL
  static List<BPFormat> _mapDigitsToZones(List<YoloV8Response> detections, List<BPFormat> templates) {
    // 1. แยกเอาเฉพาะตัวเลข (Digit) ที่ไม่ใช่ Marker
    final digits = detections.where((d) => d.label != "10").toList();

    // ดึงค่า Y ของเส้นแบ่งแต่ละโซนมา (ใช้ Y ของ Marker เป็นเกณฑ์)
    final sysY = templates[0].item.posY; 
    final diaY = templates[1].item.posY; 
    final pulY = templates[2].item.posY;

    // 2. กรองตัวเลขเข้าแต่ละลิสต์ตามพิกัด Y
    // SYS: อยู่ระหว่างเส้น 1 กับ 2
    final sysList = digits.where((e) => e.box[1] >= sysY && e.box[1] < diaY).toList();
    
    // DIA: อยู่ระหว่างเส้น 2 กับ 3
    final diaList = digits.where((e) => e.box[1] >= diaY && e.box[1] < pulY).toList();
    
    // PUL: อยู่ใต้เส้น 3 ลงไป
    final pulList = digits.where((e) => e.box[1] >= pulY).toList();

    // 3. เรียงลำดับตัวเลขจากซ้ายไปขวา (Sort X) และประกอบร่างเป็น String
    templates[0].item.value = _joinDigits(sysList);
    templates[1].item.value = _joinDigits(diaList);
    templates[2].item.value = _joinDigits(pulList);

    return templates;
  }

  /// Helper สำหรับเรียงซ้ายไปขวาแล้วต่อ String
  static String _joinDigits(List<YoloV8Response> digits) {
    if (digits.isEmpty) return "";
    
    // เรียงตามแกน X (ซ้าย -> ขวา)
    digits.sort((a, b) => a.box[0].compareTo(b.box[0]));
    
    // เอา label มาต่อกัน
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
