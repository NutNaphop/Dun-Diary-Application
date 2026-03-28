import 'dart:io';
import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:image_picker/image_picker.dart';

class MediaService {
  final ImagePicker _picker = ImagePicker();

  // ฟังก์ชันหลัก: รับค่า source ว่าจะเอาจาก "กล้อง" หรือ "แกลเลอรี"
  Future<File?> pickImage({required ImageSource source}) async {
    try {
      // 1. สั่งให้ ImagePicker ไปเอารูปมา
      // preferredCameraDevice: เลือกกล้องหลังเป็นค่าเริ่มต้น (ถ้าเลือกกล้อง)
      // imageQuality: 80 คือบีบอัดรูปนิดหน่อยให้ไม่หนักเครื่องเกินไป (แนะนำ)
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.rear,
      );

      // 2. เช็คว่า User ได้เลือกรูปไหม? (หรือกดยกเลิก)
      if (pickedFile == null) {
        return null; // ถ้ากดยกเลิก ก็ส่งค่าว่างกลับไป
      }

      return File(pickedFile.path);
    } catch (e) {
      AppLogger.error("Error picking image", e);
      return null;
    }
  }
}
