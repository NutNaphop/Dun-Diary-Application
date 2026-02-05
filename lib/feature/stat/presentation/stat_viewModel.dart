import 'package:dun_diary_app/data/analyze_record/model/analyze_result_model.dart';
import 'package:dun_diary_app/data/analyze_record/repository/analyze_repository.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/feature/stat/model/stat_model.dart';
import 'package:dun_diary_app/feature/stat/presentation/helper/stat_ui_mappper.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/analyze_card/analyze_card.dart';
import 'package:dun_diary_app/feature/stat/presentation/widgets/stat_card/stat_card.dart';
import 'package:dun_diary_app/shared/utils/analyze_utils.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';
import 'package:dun_diary_app/shared/utils/graph_data_mapper.dart';
import 'package:dun_diary_app/shared/utils/mock_data_seeder.dart';
import 'package:dun_diary_app/shared/utils/stat_utils.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/models/blood_pressure_graph_models.dart';
import 'package:flutter/material.dart';

class StatViewmodel extends ChangeNotifier {
  final BloodPressureRepository _bpRepo;
  final AnalyzeRepository _analyzeRepo;

  StatViewmodel(this._bpRepo, this._analyzeRepo) {
    _loadData();
  }

  // --- State Variables ---
  List<StatCardData> _statsData = [];
  List<StatCardData> get statsData => _statsData;

  // --- Graph Variables ---
  List<BloodPressureGraphData> _graphData = [];
  List<BloodPressureGraphData> get graphData => _graphData;

  AnalyzeState _analyzeState = AnalyzeState.idle;
  AnalyzeState get analyzeState => _analyzeState;

  AnalyzeResultModel? _aiResultContent;
  AnalyzeResultModel? get aiResultContent => _aiResultContent;

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  Future<void> seedData() async {
    print("data is seeding");
    await MockDataSeeder(_bpRepo).generateBigData();
    print("data is already seed");
  }

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    _loadData();
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

  // --- 🟣 PART 2: AI ---
  Future<void> _checkAiCache(String key, List<BPRecord> records) async {
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

  // ฟังก์ชันที่ปุ่มกดเรียกใช้
  Future<void> triggerAnalyze() async {
    _analyzeState = AnalyzeState.processing;
    notifyListeners();

    try {
      final range = DateTimeUtils.calculateDateRange(_selectedTabIndex);
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
