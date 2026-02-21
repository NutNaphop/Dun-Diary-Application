import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RecoveryFlagService {
  static const String _recoveryInProgressKey = 'recovery_in_progress';
  static const String _recoveryTargetUidKey = 'recovery_target_uid';
  static const String _pendingDeleteUidKey = 'pending_delete_uid';

  /// เช็คว่ามี recovery ค้างอยู่หรือไม่
  static bool isRecoveryPending() {
    final box = Hive.box(AuthService.settingsBoxName);
    return box.get(_recoveryInProgressKey, defaultValue: false) == true;
  }

  /// ดึง UID ที่กำลัง recovery ค้างอยู่
  static String? getPendingRecoveryUid() {
    final box = Hive.box(AuthService.settingsBoxName);
    return box.get(_recoveryTargetUidKey);
  }

  /// ตั้ง recovery flag ใน Hive (ก่อนเริ่ม destructive ops)
  static Future<void> setRecoveryFlag(String targetUid) async {
    final box = Hive.box(AuthService.settingsBoxName);
    await box.put(_recoveryInProgressKey, true);
    await box.put(_recoveryTargetUidKey, targetUid);
    AppLogger.info("🚩 Recovery flag set for $targetUid");
  }

  /// ลบ recovery flag (เมื่อ recovery สำเร็จ)
  static Future<void> clearRecoveryFlag() async {
    final box = Hive.box(AuthService.settingsBoxName);
    await box.delete(_recoveryInProgressKey);
    await box.delete(_recoveryTargetUidKey);
    AppLogger.info("🏁 Recovery flag cleared");
  }

  /// บันทึก UID ของบัญชีเก่าที่จะลบทิ้งหลังจากกู้คืนเสร็จ
  static Future<void> setPendingDeleteUid(String uid) async {
    final box = Hive.box(AuthService.settingsBoxName);
    await box.put(_pendingDeleteUidKey, uid);
    AppLogger.info("🗑️ Marked $uid for deletion after recovery");
  }

  /// ดึง UID ของบัญชีเก่าที่กู้คืนเสร็จแล้วค่อยลบ
  static String? getPendingDeleteUid() {
    final box = Hive.box(AuthService.settingsBoxName);
    return box.get(_pendingDeleteUidKey);
  }

  /// ลบข้อมูลคิวลบบัญชีทิ้ง (ใช้เมื่อลบเสร็จแล้ว)
  static Future<void> clearPendingDeleteUid() async {
    final box = Hive.box(AuthService.settingsBoxName);
    await box.delete(_pendingDeleteUidKey);
  }
}
