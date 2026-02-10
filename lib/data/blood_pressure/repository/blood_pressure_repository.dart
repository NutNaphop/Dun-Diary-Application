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
/// Flow การทำงาน:
/// 1. บันทึกข้อมูลลง Local ก่อนเสมอ (immediate response)
/// 2. ถ้ามี internet → sync ขึ้น Cloud อัตโนมัติ
/// 3. ถ้าไม่มี internet → เก็บใน Queue รอ sync ทีหลัง
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
      // Step 1: บันทึก Local ก่อน (ให้ UI ตอบสนองทันที)
      await _localDataSource.addRecord(record);
      print("✅ Repository: Saved locally. ID: ${record.id}");

      // Step 2: ถ้า online → sync ทั้งหมดที่ค้าง
      if (isOnline) await syncAllPending();

      // Debug: แสดงจำนวน record ที่ยังค้าง sync
      final remainingQueueIDs = _localDataSource.getAllRecordIdsInQueueBox();
      print(
        "✅ Sync completed. Remaining in QueueBox: ${remainingQueueIDs.length}",
      );
      for (final id in remainingQueueIDs) {
        print("   - $id");
      }
    } catch (e) {
      print("❌ Save Error: $e");
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
      print("🚫 Sync aborted: No User Logged in");
      return;
    }

    // ดึง IDs ที่รอ sync
    final pendingQueueID = _localDataSource.getAllRecordIdsInQueueBox();

    if (pendingQueueID.isEmpty) {
      print("✅ Sync: No pending records");
      return;
    }

    print("☁️ Syncing ${pendingQueueID.length} records...");

    // Loop sync ทีละ record
    for (final recordID in pendingQueueID) {
      try {
        final record = _localDataSource.getRecordById(recordID);

        if (record == null) {
          print("⚠️ Record with ID $recordID not found locally. Skipping...");
          continue;
        }

        // ส่งขึ้น Firebase (path: users/{uid}/records/{record_id})
        await _remoteDataSource.saveRecordToFirebase(record, user.uid);

        // Sync สำเร็จ → update สถานะ local
        record.isSynced = true;
        await _localDataSource.updateRecord(record);
        await _localDataSource.deleteRecordIdFromQueueBox(record.id);

        print(" -> Synced record: ${record.id}");
      } catch (e) {
        print("❌ Failed to sync record $recordID: $e");
        // ไม่ throw → ให้ทำ record อื่นต่อ
      }
    }
  }

  /// เพิ่ม Record ID เข้า Sync Queue (ใช้เมื่อ save แบบ offline)
  Future<void> saveRecordIdToQueueBox(String recordId) async {
    await _localDataSource.saveRecordIdToQueueBox(recordId);
  }

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
}
