import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';

class StatCalulatedType {
  final String avgBP;
  final String sd;
  final String maxBP;
  final String minBP;
  final DateTime? maxBPDate;
  final DateTime? minBPDate;

  StatCalulatedType({
    required this.avgBP,
    required this.sd,
    required this.maxBP,
    required this.minBP,
    this.maxBPDate,
    this.minBPDate,
  });
}

class StatSummary {
  final int avgSys;
  final int avgDia;
  final BPRecord min;
  final BPRecord max;

  StatSummary({
    required this.avgSys,
    required this.avgDia,
    required this.min,
    required this.max,
  });
}
