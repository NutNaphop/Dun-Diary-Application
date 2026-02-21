import 'package:dun_diary_app/core/services/app_logger.dart';
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
      if (_firebaseAuth.currentUser != null) {
        AppLogger.info(
          "Auth: Already logged in as ${_firebaseAuth.currentUser!.uid}",
        );
        return _firebaseAuth.currentUser;
      }

      AppLogger.info("Auth: Signing in anonymously...");
      final userCredential = await _firebaseAuth.signInAnonymously();
      AppLogger.info("Auth: Signed in new user -> ${userCredential.user!.uid}");
      return userCredential.user;
    } catch (e) {
      AppLogger.error("Auth Error", e);
      return null;
    }
  }

  /// 2. ฟังก์ชันขอ ID สำหรับบันทึก (ใช้ UUID เป็น primary key เสมอ)
  ///
  /// ลำดับการเช็ค:
  /// 1. active_uid (ถ้าเคย recovery มา)
  /// 2. local_uuid (UUID ที่สร้างเองตอนเปิดแอปครั้งแรก)
  Future<String> getUserIdForSaving() async {
    final box = Hive.box(settingsBoxName);

    // กรณี Recovery: ถ้ามี active_uid → ใช้ตัวนั้น
    String? activeUid = box.get('active_uid');
    if (activeUid != null) return activeUid;

    // กรณีปกติ: ใช้ local_uuid
    String? localUuid = box.get('local_uuid');

    // ถ้ายังไม่เคยมี Local UUID มาก่อน -> สร้างใหม่แล้วจำไว้
    if (localUuid == null) {
      localUuid = const Uuid().v4();
      await box.put('local_uuid', localUuid);
      AppLogger.info("Auth: Generated new Local UUID -> $localUuid");
    }

    return localUuid;
  }

  /// เซ็ต Active UID ใหม่ (ใช้ตอน Recovery เพื่อเปลี่ยนไปใช้ UID จากเครื่องเก่า)
  Future<void> setActiveUid(String uid) async {
    final box = Hive.box(settingsBoxName);
    await box.put('active_uid', uid);
    AppLogger.info("Auth: Set active UID -> $uid");
  }

  /// ดึง Active UID ปัจจุบัน (ใช้ตอน cleanup ก่อน recovery)
  String? getCurrentActiveUid() {
    final box = Hive.box(settingsBoxName);
    return box.get('active_uid') ?? box.get('local_uuid');
  }

  Future<void> initializeUserIdentity() async {
    final currentId = await getUserIdForSaving();
    AppLogger.info("User Identity Ready: $currentId");
  }

  // get firebase token
  Future<String?> getUserToken() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return user.getIdToken();
  }

  /// Helper: เช็คว่าตอนนี้ใช้ ID ปลอมอยู่ไหม? (เอาไว้โชว์ UI เตือน หรือไว้ใช้ตอน Migrate)
  bool get isGuest => _firebaseAuth.currentUser == null;
}
