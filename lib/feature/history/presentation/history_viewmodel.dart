import 'dart:collection';

import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:flutter/material.dart';

class HistoryViewmodel extends ChangeNotifier {
  List<BPRecord> _bpRecord = [];
  UnmodifiableListView<BPRecord> get bpRecord =>
      UnmodifiableListView(_bpRecord);

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  // Group records by date for the calendar view
  Map<DateTime, List<BPRecord>> get _recordsByDate {
    final Map<DateTime, List<BPRecord>> grouped = {};
    for (var record in _bpRecord) {
      final date = DateTime(
        record.createdAt.year,
        record.createdAt.month,
        record.createdAt.day,
      );
      if (grouped.containsKey(date)) {
        grouped[date]!.add(record);
      } else {
        grouped[date] = [record];
      }
    }
    return grouped;
  }

  // Get records for the currently selected date
  UnmodifiableListView<BPRecord> get selectedDateRecords {
    final date = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    return UnmodifiableListView(_recordsByDate[date] ?? []);
  }

  // Get average level for a specific date (for bubble color)
  int? getAverageLevelForDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    final records = _recordsByDate[dateKey];

    if (records == null || records.isEmpty) return null;

    // Calculate level for each record
    final levels = records
        .map(
          (r) => BloodPressureUtils.calculateBloodPressureLevel(r.sys, r.dia),
        )
        .toList();

    return BloodPressureUtils.calculateAVGLevel(levels);
  }

  // Get latest date from records or Today
  DateTime get latestDataDate {
    final now = DateTime.now();
    if (_bpRecord.isEmpty) return now;

    final latestRecord = _bpRecord
        .map((e) => e.createdAt)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    return latestRecord.isAfter(now) ? latestRecord : now;
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  HistoryViewmodel() {
    _generateMockData();
  }

  void _generateMockData() {
    _bpRecord = [
      BPRecord(
        id: '1',
        ownerId: 'user1',
        sys: 120,
        dia: 80,
        pulse: 70,
        createdAt: DateTime.now(),
      ),
      BPRecord(
        id: '2',
        ownerId: 'user1',
        sys: 130,
        dia: 85,
        pulse: 72,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      BPRecord(
        id: '3',
        ownerId: 'user1',
        sys: 110,
        dia: 75,
        pulse: 68,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      BPRecord(
        id: '4',
        ownerId: 'user1',
        sys: 140,
        dia: 90,
        pulse: 80,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      BPRecord(
        id: '5',
        ownerId: 'user1',
        sys: 115,
        dia: 78,
        pulse: 71,
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
    ];
    notifyListeners();
  }
}
