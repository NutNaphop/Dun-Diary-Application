import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:dun_diary_app/data/blood_pressure/datasource/blood_pressure_remote_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../datasource/blood_pressure_local_data_source.dart';
import '../model/bp_record.dart';

/// Repository สำหรับจัดการข้อมูล Blood Pressure Records
///
/// ทำหน้าที่เป็น Single Source of Truth โดยรวม:
/// - Local Storage (Hive) สำหรับ offline-first
/// - Remote Storage (Firebase) สำหรับ sync ข้อมูลขึ้น Cloud
///
/// Flow การทำงานใหม่ (2-Queue Strategy):
/// 1. บันทึกข้อมูลลง Local
/// 2. ใส่ ID ลง Queue (Upsert หรือ Delete) ทันที
/// 3. ถ้ามี internet → เรียก syncAllPending() เพื่อเคลียร์ Queue
class BloodPressureRepository {
  final BloodPressureLocalDataSource _localDataSource;
  final BloodPressureRemoteDataSource _remoteDataSource;

  BloodPressureRepository({
    required BloodPressureLocalDataSource localDataSource,
    required BloodPressureRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  // ===========================================================================
  // 📝 SECTION 1: Record CRUD Operations
  // ===========================================================================

  /// บันทึก Record ใหม่ (Local-first strategy)
  ///
  /// [record] - ข้อมูลความดันที่จะบันทึก
  /// [isOnline] - สถานะ internet connection
  ///
  /// Flow:
  /// 1. บันทึกลง Local ทันที
  /// 2. ถ้า online → trigger sync ที่ค้างอยู่ทั้งหมด
  Future<void> saveRecord(BPRecord record, bool isOnline) async {
    try {
      // Step 1: บันทึก Local ก่อน
      await _localDataSource.addRecord(record);
      AppLogger.info("Repository: Saved locally. ID: ${record.id}");

      // 2. เข้าคิว Upsert เสมอ (กันพลาด)
      await _localDataSource.enqueueUpsert(record.id);
      AppLogger.info("Repo: Saved & Enqueued ${record.id}");

      // 3. ถ้า Online -> ยิง Sync เลย
      if (isOnline) await syncAllPending();
    } catch (e) {
      AppLogger.error("Save Error", e);
      rethrow;
    }
  }

  /// ดึง Records ทั้งหมดจาก Local (เรียงจากใหม่ไปเก่า)
  List<BPRecord> getAllRecords() {
    return _localDataSource.getAllRecords();
  }

  /// ดึง Record ล่าสุด
  BPRecord? getLatestRecord() {
    return _localDataSource.getLatestRecord();
  }

  /// ดึง Record ล่าสุดของวันนี้
  BPRecord? getLatestTodayRecord() {
    return _localDataSource.getLatestTodayRecord();
  }

  /// Stream สำหรับ listen การเปลี่ยนแปลงของ Records
  Stream<dynamic> watchRecords() {
    return _localDataSource.watchRecords();
  }

  // Update Record
  Future<void> updateRecord(BPRecord record, bool isOnline) async {
    try {
      // Step 1: บันทึก Local ก่อน (ให้ UI ตอบสนองทันที)
      await _localDataSource.updateRecord(record);

      // 2. เข้าคิว Upsert (ถ้ามีอยู่แล้วมันจะไม่ซ้ำ)
      await _localDataSource.enqueueUpsert(record.id);
      AppLogger.info("Repo: Updated & Enqueued ${record.id}");

      // 3. ถ้า Online -> ยิง Sync เลย
      if (isOnline) await syncAllPending();
    } catch (e) {
      AppLogger.error("Update Error", e);
      rethrow;
    }
  }

  // Delete Record
  Future<void> deleteRecord(String id, bool isOnline) async {
    try {
      // 1. ลบ Local (ทำเหมือนเดิม)
      await _localDataSource.deleteRecord(id);

      // 2. เข้าคิว Delete (ระบบจะเช็คเองว่าถ้าเพิ่งสร้างจะไม่อยู่ในคิวนี้)
      await _localDataSource.enqueueDelete(id);
      AppLogger.info("Repo: Deleted & Processed Queue logic for $id");

      // 3. ถ้า Online -> ยิง Sync เลย
      if (isOnline) await syncAllPending();
    } catch (e) {
      AppLogger.error("Delete Error", e);
      rethrow;
    }
  }

  /// 🧪 Debug: ลบข้อมูล Local ทั้งหมด
  void deleteAllLocalData() {
    _localDataSource.getAllRecords().forEach((record) {
      _localDataSource.deleteRecord(record.id);
    });
  }

  // ===========================================================================
  // 🔄 SECTION 2: Cloud Sync Operations
  // ===========================================================================

  /// Sync Records ที่ค้างอยู่ใน Queue ขึ้น Firebase
  ///
  /// Algorithm:
  /// 1. ตรวจสอบ user login
  /// 2. ดึง IDs จาก QueueBox
  /// 3. Loop ส่งขึ้น Firebase ทีละ record
  /// 4. ถ้าสำเร็จ → mark isSynced = true + ลบออกจาก Queue
  Future<void> syncAllPending() async {
    // ต้อง login ก่อนถึงจะ sync ได้
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      AppLogger.warning("Sync aborted: No User Logged in");
      return;
    }

    AppLogger.info("Starting Sync Process...");

    // -------------------------------------------------
    // Phase 1: Manage item need to delete first
    // -------------------------------------------------
    final deleteIds = _localDataSource.getDeleteQueueIds();
    if (deleteIds.isNotEmpty) {
      AppLogger.debug("Processing Delete Queue (${deleteIds.length} items)...");
      for (final id in deleteIds) {
        try {
          // สั่งลบบน Firebase
          await _remoteDataSource.deleteRecordFromFirebase(id, user.uid);

          // สำเร็จ -> ลบออกจาก Queue
          await _localDataSource.clearFromDeleteQueue(id);
          AppLogger.debug("   -> Deleted remote: $id");
        } catch (e) {
          AppLogger.error("Failed to delete remote $id", e);
          // ปล่อยไว้ใน Queue รอ Sync รอบหน้า
        }
      }
    }

    // -------------------------------------------------
    // Phase 2: Manage Item need to add/update first
    // -------------------------------------------------
    final upsertIds = _localDataSource.getUpsertQueueIds();
    if (upsertIds.isNotEmpty) {
      AppLogger.debug("Processing Upsert Queue (${upsertIds.length} items)...");
      for (final id in upsertIds) {
        try {
          final record = _localDataSource.getRecordById(id);

          // กรณีหายาก: ID อยู่ใน Queue แต่ตัวข้อมูลหายไปจาก Box แล้ว
          if (record == null) {
            AppLogger.warning(
              "Record $id not found in box. Removing from queue.",
            );
            await _localDataSource.clearFromUpsertQueue(id);
            continue;
          }

          // ส่งขึ้น Firebase (ใช้ .set ทับได้เลยทั้ง Add/Edit)
          await _remoteDataSource.saveRecordToFirebase(record, user.uid);

          // Sync สำเร็จ -> update สถานะ isSynced = true
          record.isSynced = true;
          await _localDataSource.updateRecord(record);

          // ลบออกจาก Queue
          await _localDataSource.clearFromUpsertQueue(id);
          AppLogger.debug("   -> Synced upsert: $id");
        } catch (e) {
          AppLogger.error("Failed to sync upsert $id", e);
        }
      }
    }
    AppLogger.info("Sync Process Completed.");
  }

  // /// เพิ่ม Record ID เข้า Sync Queue (ใช้เมื่อ save แบบ offline)
  // Future<void> saveRecordIdToQueueBox(String recordId) async {
  //   await _localDataSource.saveRecordIdToQueueBox(recordId);
  // }

  // ===========================================================================
  // 📈 SECTION 3: Metadata & Range Queries
  // ===========================================================================

  /// ดึงปีที่เก่าที่สุดที่มีข้อมูล (ใช้กำหนด firstDate ของ Calendar)
  int getMinYear() {
    return _localDataSource.getMinYear();
  }

  /// ดึงรายการปีที่มีข้อมูล
  List<int> getActiveYears() {
    return _localDataSource.getActiveYears();
  }

  /// ดึง Records ตามเดือน
  List<BPRecord> getRecordsByMonth(int year, int month) {
    return _localDataSource.getRecordsByMonth(year, month);
  }

  /// ดึง Records ตามช่วงเวลา (start - end)
  List<BPRecord> getRecordsByRange(DateTime start, DateTime end) {
    return _localDataSource.getRecordsByRange(start, end);
  }

  // ===========================================================================
  // 🔧 SECTION 4: Debug / Testing Tools
  // ===========================================================================

  /// 🔥 HARD RESET: ลบข้อมูลทิ้งทั้งหมดทั้ง Local และ Cloud
  Future<void> debugClearAllData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _remoteDataSource.deleteAllRecords(user.uid);
      }

      await _localDataSource.clearAll();
    } catch (e) {
      print("❌ Hard Reset Error: $e");
      rethrow;
    }
  }
}
