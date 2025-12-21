import 'package:dun_diary_app/core/constant/hive_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Box _settingsBox = Hive.box(HiveBoxName.settingsBox); // อย่าลืมเปิดใน main

  // ฟังก์ชันพระเอก: ขอ ID สำหรับการบันทึกข้อมูล
  Future<String> getUserIdForSaving() async {
    // 1. ถ้ามี Firebase User (Online) ใช้ UID จริง
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) return currentUser.uid;

    // 2. ถ้า Offline -> เช็คว่ามี UUID เดิมไหม
    String? localId = _settingsBox.get('local_uuid');

    // 3. ถ้าไม่มีเลย (เพิ่งบันทึกครั้งแรกของชีวิต) -> สร้างใหม่เดี๋ยวนั้น!
    if (localId == null) {
      localId = const Uuid().v4();
      await _settingsBox.put('local_uuid', localId);
      print("🆕 Generated New Local UUID: $localId");
    }
    
    return localId;
  }

  // Login แบบไม่ระบุตัวตน
  Future<UserCredential?> signInAnonymously() async {
    try {
      return await _firebaseAuth.signInAnonymously();
    } catch (e) {
      print("Login Failed: $e");
      return null;
    }
  }

  // เช็คว่าตอนนี้เราใช้ ID ปลอมอยู่ไหม (เพื่อตัดสินใจ Migrate)
  bool get isUsingLocalId => _settingsBox.containsKey('local_uuid');
}