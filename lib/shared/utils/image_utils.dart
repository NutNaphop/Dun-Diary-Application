import 'dart:io';
import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageUtils {
  // ฟังก์ชันนี้ทำงานแบบ Async และเรียก Native Code (เร็วปรู๊ด)
  static Future<File?> compressAndFix(File file) async {
    try {
      // 1. หาที่วางไฟล์ Temp
      final tempDir = await getTemporaryDirectory();

      // ตั้งชื่อไฟล์ปลายทาง (ต้องไม่ซ้ำไฟล์เดิม)
      final String targetPath = p.join(
        tempDir.path,
        "optimized_${DateTime.now().millisecondsSinceEpoch}.jpg",
      );

      // 2. คำสั่งเทพ: หมุน + ย่อ + แปลงไฟล์ ในคำสั่งเดียว
      var resultXFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        minWidth: 640, // ย่อให้ด้านสั้นที่สุดไม่ต่ำกว่า 640
        minHeight: 640,
        quality: 90, // คุณภาพ 90% (เหลือเฟือสำหรับ AI)
        rotate: 0, // autoCorrectionAngle: true โดย default (หมุนตาม EXIF)
        keepExif: false, // ลบ EXIF ทิ้งไปเลย ได้ภาพตั้งตรง 100%
        format: CompressFormat.jpeg,
      );

      if (resultXFile == null) return null;
      return File(resultXFile.path);
    } catch (e) {
      AppLogger.error("Image Compression Error", e);
      return null;
    }
  }
}
