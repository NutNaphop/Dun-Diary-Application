import 'dart:async';
import 'dart:collection';

import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';
import 'package:dun_diary_app/shared/utils/mock_data_seeder.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/models/blood_pressure_graph_models.dart';
import 'package:flutter/material.dart';

class HistoryViewmodel extends ChangeNotifier {
  final BloodPressureRepository _repository;
  StreamSubscription? _subscription;

  HistoryViewmodel({required BloodPressureRepository repository})
    : _repository = repository {
    _init();
  }

  final Map<String, List<BPRecord>> _monthlyCache = {};
  final Set<String> _loadedMonths = {};

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  Future<void> _loadDataWindow(DateTime date) async {
    final currentKey = DateTimeUtils.getYearMonthKey(date);
    final prevKey = DateTimeUtils.getYearMonthKey(
      DateTime(date.year, date.month - 1),
    );
    final nextKey = DateTimeUtils.getYearMonthKey(
      DateTime(date.year, date.month + 1),
    );

    await Future.wait([
      _fetchMonthByKey(currentKey),
      _fetchMonthByKey(prevKey),
      _fetchMonthByKey(nextKey),
    ]);

    notifyListeners();
  }

  Future<void> seedData() async {
    await MockDataSeeder(_repository).generateBigData();
  }

  Future<void> _fetchMonthByKey(String key) async {
    if (_loadedMonths.contains(key)) return;

    final parts = key.split('_');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);

    final records = _repository.getRecordsByMonth(year, month);
    records.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    _monthlyCache[key] = records;
    _loadedMonths.add(key);
  }

  UnmodifiableListView<BPRecord> get selectedDateRecords {
    final key = DateTimeUtils.getYearMonthKey(_selectedDate);
    final monthRecords = _monthlyCache[key] ?? [];

    final dailyRecords = monthRecords
        .where(
          (r) =>
              r.createdAt.day == _selectedDate.day &&
              r.createdAt.month == _selectedDate.month &&
              r.createdAt.year == _selectedDate.year,
        )
        .toList();

    return UnmodifiableListView(dailyRecords);
  }

  int? getAverageLevelForDate(DateTime date) {
    final key = DateTimeUtils.getYearMonthKey(date);
    final monthRecords = _monthlyCache[key];

    if (monthRecords == null) return null;

    final dailyRecs = monthRecords
        .where((r) => r.createdAt.day == date.day)
        .toList();
    if (dailyRecs.isEmpty) return null;

    final levels = dailyRecs
        .map(
          (r) => BloodPressureUtils.calculateBloodPressureLevel(r.sys, r.dia),
        )
        .toList();

    return BloodPressureUtils.calculateAVGLevel(levels);
  }

  DateTime get latestDataDate {
    final latest = _repository.getLatestRecord();
    final now = DateTime.now();

    if (latest != null && latest.createdAt.isAfter(now)) {
      return latest.createdAt;
    }
    return now;
  }

  List<BloodPressureGraphData> get selectedDateGraphData {
    return BloodPressureUtils.mapToGraphData(selectedDateRecords);
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    _loadDataWindow(date);
  }

  void _init() {
    _loadDataWindow(_selectedDate);

    // Listen การเปลี่ยนแปลง (เช่น บันทึกใหม่)
    _subscription = _repository.watchRecords().listen((_) {
      // ⚠️ ข้อมูลเปลี่ยน: เคลียร์ Cache แล้วโหลดใหม่
      _loadedMonths.clear();
      _monthlyCache.clear();
      _loadDataWindow(_selectedDate);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
