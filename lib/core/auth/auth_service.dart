import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  // ชื่อกล่องเก็บตั้งค่า (ต้องตรงกับที่ openBox ใน main.dart)
  static const String settingsBoxName = 'settings'; 

  /// 1. ฟังก์ชัน Login (เรียกตอนเปิดแอป)
  Future<User?> signInAnonymously() async {
    try {
      // ถ้ามี User อยู่แล้ว ไม่ต้อง Login ซ้ำ
      if (_firebaseAuth.currentUser != null) {
        print("✅ Auth: Already logged in as ${_firebaseAuth.currentUser!.uid}");
        return _firebaseAuth.currentUser;
      }

      // ถ้ายังไม่มี -> สั่ง Login
      print("⏳ Auth: Signing in anonymously...");
      final userCredential = await _firebaseAuth.signInAnonymously();
      print("✅ Auth: Signed in new user -> ${userCredential.user!.uid}");
      return userCredential.user;
      
    } catch (e) {
      print("❌ Auth Error: $e");
      return null;
    }
  }

  /// 2. ฟังก์ชันขอ ID สำหรับบันทึก (พระเอกของเรา)
  /// เรียกใช้ตอนกดปุ่ม Save: authService.getUserIdForSaving()
  Future<String> getUserIdForSaving() async {
    // กรณีที่ 1: ถ้า Login Firebase อยู่ -> ใช้ UID จริงเลย
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      return firebaseUser.uid;
    }

    // กรณีที่ 2: ถ้าไม่มีเน็ต/ยังไม่ Login -> ใช้ Local UUID
    final box = Hive.box(settingsBoxName);
    String? localUuid = box.get('local_uuid');

    // ถ้ายังไม่เคยมี Local UUID มาก่อน -> สร้างใหม่แล้วจำไว้
    if (localUuid == null) {
      localUuid = const Uuid().v4();
      await box.put('local_uuid', localUuid);
      print("⚠️ Auth: Generated new Local UUID -> $localUuid");
    } else {
      print("⚠️ Auth: Using existing Local UUID -> $localUuid");
    }

    return localUuid;
  }
  
  /// Helper: เช็คว่าตอนนี้ใช้ ID ปลอมอยู่ไหม? (เอาไว้โชว์ UI เตือน หรือไว้ใช้ตอน Migrate)
  bool get isGuest => _firebaseAuth.currentUser == null;
}