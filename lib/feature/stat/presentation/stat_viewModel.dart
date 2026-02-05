// file: feature/stat/presentation/stat_viewModel.dart

import 'package:dun_diary_app/data/analyze_record/repository/analyze_repository.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/feature/stat/model/stat_model.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/feature/stat/presentation/helper/stat_ui_mappper.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/analyze_card/analyze_card.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/stat_card/stat_card.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';
import 'package:dun_diary_app/shared/utils/graph_data_mapper.dart';
import 'package:dun_diary_app/shared/utils/mock_data_seeder.dart';
import 'package:dun_diary_app/shared/utils/stat_utils.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/models/blood_pressure_graph_models.dart';
import 'package:flutter/material.dart';

class StatViewmodel extends ChangeNotifier {
  // 1. รับ Repository เข้ามา
  final BloodPressureRepository _bpRepo;
  final AnalyzeRepository _analyzeRepo;

  StatViewmodel(this._bpRepo, this._analyzeRepo) {
    _loadData(); // เกิดมาปุ๊บ โหลดข้อมูลปั๊บ
  }

  // --- State Variables ---
  List<StatCardData> _statsData = [];
  List<StatCardData> get statsData => _statsData;

  // --- Graph Variables ---
  List<BloodPressureGraphData> _graphData = [];
  List<BloodPressureGraphData> get graphData => _graphData;

  AnalyzeState _analyzeState = AnalyzeState.idle;
  AnalyzeState get analyzeState => _analyzeState;

  String? _aiResultContent;
  String? get aiResultContent => _aiResultContent;

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  Future<void> seedData() async {
    print("data is seeding");
    await MockDataSeeder(_bpRepo).generateBigData();
    print("data is already seed");
  }

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    _loadData(); // เปลี่ยนแท็บ -> โหลดข้อมูลใหม่
  }

  // --- 🟢 PART 1: โหลดข้อมูล & คำนวณสถิติ ---
  Future<void> _loadData() async {
    final range = DateTimeUtils.calculateDateRange(_selectedTabIndex);
    final records = _bpRepo.getRecordsByRange(range.start, range.end);
    final StatCalulatedType statMap = StatUtils.calculate(records);

    _statsData = StatUiMappper.mapToCardData(statMap);
    _graphData = GraphDataMapper.mapToGraphData(records, _selectedTabIndex);

    await _checkAiCache(range.key, records);

    notifyListeners();
  }

  // --- 🟣 PART 2: ระบบ AI ---
  Future<void> _checkAiCache(String key, List<BPRecord> records) async {
    // สร้างลายเซ็นข้อมูลปัจจุบัน (ต้องทำ fn นี้ใน Utils หรือ Repo)
    // final currentSig = generateDataSignature(records);

    // ดึง Cache มาดู
    final cache = _analyzeRepo.getCachedAnalysis(key);

    // *สมมติว่าเช็ค Signature แล้วตรงกัน (ถ้ายังไม่ได้ทำ Signature ข้ามไปก่อนได้)*
    if (cache != null) {
      _analyzeState = AnalyzeState.success;
      _aiResultContent = cache.content;
    } else {
      _analyzeState = AnalyzeState.idle;
      _aiResultContent = null;
    }
  }

  // ฟังก์ชันที่ปุ่มกดเรียกใช้
  Future<void> triggerAnalyze() async {
    _analyzeState = AnalyzeState.processing;
    notifyListeners();

    try {
      final range = DateTimeUtils.calculateDateRange(_selectedTabIndex);
      final records = _bpRepo.getRecordsByRange(range.start, range.end);

      // ... ตรงนี้เรียก AnalyzeRepo.analyzeAndSave ...
      // รอ Mission ถัดไปเรื่องต่อ API จริงๆ เดี๋ยวใส่ Mock ไปก่อน

      await Future.delayed(Duration(seconds: 2)); // แกล้งโหลด
      _analyzeState = AnalyzeState.success;
      _aiResultContent = "สุขภาพความดันของคุณอยู่ในเกณฑ์ดีมาก..."; // Mock
    } catch (e) {
      _analyzeState = AnalyzeState.error;
    }
    notifyListeners();
  }
}
