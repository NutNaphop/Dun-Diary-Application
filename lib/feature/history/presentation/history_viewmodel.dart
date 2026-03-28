import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/services/export_service.dart';
import 'package:dun_diary_app/core/services/flushbar_service.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/feature/record/presentation/record_screen.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';
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

  DateTime? _exportStartDate;
  DateTime? get exportStartDate => _exportStartDate;

  DateTime? _exportEndDate;
  DateTime? get exportEndDate => _exportEndDate;

  bool _isExporting = false;
  bool get isExporting => _isExporting;

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

  BPLevel? getAverageLevelForDate(DateTime date) {
    final key = DateTimeUtils.getYearMonthKey(date);
    final monthRecords = _monthlyCache[key];

    if (monthRecords == null) return null;

    final dailyRecs = monthRecords
        .where((r) => r.createdAt.day == date.day)
        .toList();
    if (dailyRecs.isEmpty) return null;

    return BloodPressureUtils.calculateOverallRiskLevel(
      dailyRecs,
      isStrict: false,
    );
  }

  bool hasHighLevelRecord(DateTime date) {
    final key = DateTimeUtils.getYearMonthKey(date);
    final monthRecords = _monthlyCache[key];
    if (monthRecords == null) return false;
    return monthRecords
        .where(
          (r) =>
              r.createdAt.day == date.day &&
              r.createdAt.month == date.month &&
              r.createdAt.year == date.year,
        )
        .any((r) {
          final level = BloodPressureUtils.calculateBloodPressureLevel(
            r.sys,
            r.dia,
          );
          return level.isDangerous;
        });
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
    final sortedDateRecord = selectedDateRecords.toList();
    sortedDateRecord.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return BloodPressureUtils.mapToGraphData(sortedDateRecord);
  }

  void redirectToRecord() {
    final customSelectedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      DateTime.now().hour,
      DateTime.now().minute,
      DateTime.now().second,
    );
    final args = RecordScreenArgs(initialDate: customSelectedDate);
    NavigationService.instance.pushNamed(AppRoutes.record, arguments: args);
  }

  void redirectToBloodPressureDetail(BPRecord record) {
    final args = RecordScreenArgs(record: record);
    NavigationService.instance.pushNamed(AppRoutes.record, arguments: args);
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    _loadDataWindow(date);
  }

  void _init() {
    _loadDataWindow(_selectedDate);

    _subscription = _repository.watchRecords().listen((_) {
      _loadedMonths.clear();
      _monthlyCache.clear();
      _loadDataWindow(_selectedDate);
    });
  }

  // Export Data Section
  void setExportStartDate(DateTime date) {
    // Force to 1st of month
    _exportStartDate = DateTime(date.year, date.month, 1);

    // ถ้าวันจบ น้อยกว่าวันเริ่ม ให้รีเซ็ตวันจบ (กันงง)
    if (_exportEndDate != null && _exportEndDate!.isBefore(_exportStartDate!)) {
      _exportEndDate = null;
    }
    notifyListeners();
  }

  void setExportEndDate(DateTime date) {
    // Force to 1st of month
    _exportEndDate = DateTime(date.year, date.month, 1);
    notifyListeners();
  }

  void resetExportState() {
    _exportStartDate = null;
    _exportEndDate = null;
    notifyListeners();
  }

  void exportToCsv() async {
    if (_exportStartDate == null || _exportEndDate == null) return;
    _isExporting = true;
    notifyListeners();
    try {
      // Calculate end of the selected end month
      final endOfDay = DateTime(
        _exportEndDate!.year,
        _exportEndDate!.month + 1,
        0, // Last day of current month
        23,
        59,
        59,
      );
      final records = _repository.getRecordsByRange(
        _exportStartDate!,
        endOfDay,
      );

      await ExportService.instance.exportToCsv(records);
      FlushbarService.instance.showSuccess("ส่งออกสำเร็จ");
    } catch (e) {
      FlushbarService.instance.showError("ส่งออกไม่สำเร็จ โปรดลองอีกครั้ง");
    } finally {
      _isExporting = false;
      notifyListeners();
    }
  }

  Future exportImage(Uint8List imageBytes) async {
    _isExporting = true;
    notifyListeners();

    try {
      await ExportService.instance.saveToGallery(imageBytes);
      FlushbarService.instance.showSuccess(AppStrings.history.saveImageSuccess);
      await ExportService.instance.shareImage(imageBytes);
    } catch (e) {
      FlushbarService.instance.showError(AppStrings.history.saveImageError);
    } finally {
      _isExporting = false;
      notifyListeners();
      NavigationService.instance.goBack();
    }
  }

  // Share Image
  Future<void> shareImage(Uint8List imageBytes) async {
    _isExporting = true;
    notifyListeners();
    try {
      await ExportService.instance.shareImage(imageBytes);
    } catch (e) {
      FlushbarService.instance.showError(AppStrings.history.shareImageError);
    } finally {
      _isExporting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
