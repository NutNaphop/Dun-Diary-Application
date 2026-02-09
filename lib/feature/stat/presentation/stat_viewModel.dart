import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/data/analyze_record/model/analyze_result_model.dart';
import 'package:dun_diary_app/data/analyze_record/repository/analyze_repository.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/feature/stat/model/stat_model.dart';
import 'package:dun_diary_app/feature/stat/presentation/helper/stat_ui_mappper.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/analyze_card/analyze_card.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/stat_card/stat_card.dart';
import 'package:dun_diary_app/shared/utils/analyze_utils.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';
import 'package:dun_diary_app/shared/utils/graph_data_mapper.dart';
import 'package:dun_diary_app/shared/utils/mock_data_seeder.dart';
import 'package:dun_diary_app/shared/utils/stat_utils.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/models/blood_pressure_graph_models.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/models/calendar_types.dart';
import 'package:dun_diary_app/shared/widgets/ui/calendar_sdk/utils/calendar_utils.dart';
import 'package:flutter/material.dart';

/// ViewModel สำหรับ Stat Screen
///
/// รับผิดชอบ:
/// - โหลดและคำนวณสถิติความดันโลหิต (ค่าเฉลี่ย, SD, ค่าสูง/ต่ำสุด)
/// - จัดการ Tab (Week/Month/Year) และ Calendar navigation
/// - เรียก AI วิเคราะห์ข้อมูล + จัดการ cache
/// - ตรวจสอบ Internet connectivity
class StatViewmodel extends ChangeNotifier {
  final BloodPressureRepository _bpRepo;
  final AnalyzeRepository _analyzeRepo;
  final NetworkInfo _networkInfo;

  StatViewmodel(this._bpRepo, this._analyzeRepo, this._networkInfo) {
    _loadData();
  }

  // ===========================================================================
  // 📊 SECTION 1: State Variables
  // ===========================================================================

  /// ข้อมูลสถิติสำหรับแสดงใน StatCard (ค่าเฉลี่ย, SD, ค่าสูง/ต่ำสุด)
  List<StatCardData> _statsData = [];
  List<StatCardData> get statsData => _statsData;

  /// ระดับความดันโลหิตจากค่าเฉลี่ย (0-5, null = ไม่มีข้อมูล)
  int? _bloodPressureLevel;
  int? get bloodPressureLevel => _bloodPressureLevel;

  /// ข้อมูลสำหรับแสดงกราฟ
  List<BloodPressureGraphData> _graphData = [];
  List<BloodPressureGraphData> get graphData => _graphData;

  // ===========================================================================
  // 🤖 SECTION 2: AI Analyze State
  // ===========================================================================

  /// สถานะการวิเคราะห์ AI (idle, processing, success, error, noData)
  AnalyzeState _analyzeState = AnalyzeState.idle;
  AnalyzeState get analyzeState => _analyzeState;

  /// ผลลัพธ์จาก AI (null ถ้ายังไม่เคยวิเคราะห์)
  AnalyzeResultModel? _aiResultContent;
  AnalyzeResultModel? get aiResultContent => _aiResultContent;

  // ===========================================================================
  // 🌐 SECTION 3: Network State
  // ===========================================================================

  /// สถานะ Internet connection (ใช้ enable/disable ปุ่ม AI)
  bool _isInternetConnected = true;
  bool get isInternetConnected => _isInternetConnected;

  // ===========================================================================
  // 📅 SECTION 4: Tab & Calendar State
  // ===========================================================================

  /// Tab Index (0 = Week, 1 = Month, 2 = Year)
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  /// วันที่อ้างอิงสำหรับคำนวณ date range
  DateTime _focusedDate = DateTime.now();
  DateTime get focusedDate => _focusedDate;

  /// Label แสดงช่วงเวลา เช่น "3 ก.พ. - 9 ก.พ. 2569"
  String get currentRangeLabel =>
      DateTimeUtils.getRangeLabel(_selectedTabIndex, _focusedDate);

  /// ประเภท Calendar สำหรับแสดง CalendarSDK
  CalendarType get currentCalendarType =>
      CalendarUtils.getCalendarTypeFromTabIndex(_selectedTabIndex);

  // ===========================================================================
  // 🎮 SECTION 5: User Actions
  // ===========================================================================

  /// เมื่อผู้ใช้เลือกวันที่จาก Calendar
  void onCalendarDateSelected(DateTime date) {
    _focusedDate = date;
    _loadData();
    notifyListeners();
  }

  /// เมื่อผู้ใช้เปลี่ยน Tab (Week/Month/Year)
  void setTabIndex(int index) {
    _selectedTabIndex = index;
    _focusedDate = DateTime.now(); // Reset เป็นวันนี้เสมอ
    _loadData();
  }

  /// เมื่อผู้ใช้เลือกวันที่ (จาก DatePicker อื่น)
  void pickDate(DateTime newDate) {
    _focusedDate = newDate;
    _loadData();
  }

  /// 🧪 Debug: สร้าง Mock Data สำหรับทดสอบ
  Future<void> seedData() async {
    await MockDataSeeder(_bpRepo).generateBigData();
    _loadData();
  }

  void redirectToRecord() async {
    final didSave = await NavigationService.instance.pushNamed(
      AppRoutes.record,
    );
    if (didSave == true) {
      _loadData();
    }
  }

  // ===========================================================================
  // 🔄 SECTION 6: Data Loading & Calculation
  // ===========================================================================

  /// โหลดข้อมูลและคำนวณสถิติใหม่ทั้งหมด
  ///
  /// Flow:
  /// 1. ตรวจสอบ Internet
  /// 2. คำนวณ date range จาก tab + focusedDate
  /// 3. ดึง records จาก Repository
  /// 4. คำนวณสถิติ (avg, SD, min, max)
  /// 5. Map ข้อมูลสำหรับ UI (StatCard, Graph)
  /// 6. ตรวจสอบ AI cache
  Future<void> _loadData() async {
    // Step 1: ตรวจสอบ Internet
    _isInternetConnected = await _networkInfo.isConnected;

    // Step 2: คำนวณ date range
    final range = DateTimeUtils.calculateDateRange(
      _selectedTabIndex,
      _focusedDate,
    );

    // Step 3: ดึง records
    final records = _bpRepo.getRecordsByRange(range.start, range.end);

    // Step 4: คำนวณสถิติ
    final StatCalulatedType statMap = StatUtils.calculate(records);

    // Step 5: Map ข้อมูลสำหรับ UI
    final sys = statMap.avgSys;
    final dia = statMap.avgDia;
    _bloodPressureLevel = (sys != null && dia != null)
        ? BloodPressureUtils.calculateBloodPressureLevel(sys, dia)
        : null;
    _statsData = StatUiMappper.mapToCardData(statMap);
    _graphData = GraphDataMapper.mapToGraphData(records, _selectedTabIndex);

    // Step 6: ตรวจสอบ AI cache
    await _checkAiCache(range.key, records);

    notifyListeners();
  }

  // ===========================================================================
  // 🤖 SECTION 7: AI Analysis
  // ===========================================================================

  /// ตรวจสอบว่ามี AI cache หรือไม่
  ///
  /// Logic:
  /// - ถ้าไม่มี records → state = noData
  /// - ถ้ามี cache ที่ตรงกับ signature → state = success
  /// - ถ้าไม่มี cache หรือ signature ไม่ตรง → state = idle
  Future<void> _checkAiCache(String key, List<BPRecord> records) async {
    if (records.isEmpty) {
      _analyzeState = AnalyzeState.noData;
      _aiResultContent = null;
      return;
    }

    final currentSig = AnalyzeUtils.generateDataSignature(records);
    final cache = _analyzeRepo.getCachedAnalysis(key);

    if (cache != null && cache.dataSignature == currentSig) {
      _analyzeState = AnalyzeState.success;
      _aiResultContent = cache.content;
    } else {
      _analyzeState = AnalyzeState.idle;
      _aiResultContent = null;
    }
  }

  /// ฟังก์ชันที่ปุ่ม "วิเคราะห์" เรียกใช้
  ///
  /// Flow:
  /// 1. เปลี่ยน state เป็น processing
  /// 2. ดึง records ใหม่
  /// 3. เรียก AI API
  /// 4. บันทึก cache
  /// 5. อัปเดต state (success/error)
  Future<void> triggerAnalyze() async {
    _analyzeState = AnalyzeState.processing;
    notifyListeners();

    try {
      final range = DateTimeUtils.calculateDateRange(
        _selectedTabIndex,
        _focusedDate,
      );
      final records = _bpRepo.getRecordsByRange(range.start, range.end);
      final signature = AnalyzeUtils.generateDataSignature(records);

      final result = await _analyzeRepo.analyzeAndSave(
        key: range.key,
        records: records,
        signature: signature,
      );
      _analyzeState = AnalyzeState.success;
      _aiResultContent = result.content;
    } catch (e) {
      print(e);
      _analyzeState = AnalyzeState.error;
    }
    notifyListeners();
  }
}
