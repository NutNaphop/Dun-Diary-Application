import 'dart:collection';

import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:flutter/material.dart';

class HistoryViewmodel extends ChangeNotifier {
  List<BPRecord> _bpRecord = [];
  UnmodifiableListView<BPRecord> get bpRecord =>
      UnmodifiableListView(_bpRecord);

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
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      BPRecord(
        id: '2',
        ownerId: 'user1',
        sys: 130,
        dia: 85,
        pulse: 72,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      BPRecord(
        id: '3',
        ownerId: 'user1',
        sys: 110,
        dia: 75,
        pulse: 68,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      BPRecord(
        id: '4',
        ownerId: 'user1',
        sys: 140,
        dia: 90,
        pulse: 80,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      BPRecord(
        id: '5',
        ownerId: 'user1',
        sys: 115,
        dia: 78,
        pulse: 71,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];
    notifyListeners();
  }
}
