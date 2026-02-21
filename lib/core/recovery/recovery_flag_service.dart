import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RecoveryFlagService {
  static const String _recoveryInProgressKey = 'recovery_in_progress';
  static const String _recoveryTargetUidKey = 'recovery_target_uid';

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
}
