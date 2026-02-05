import 'dart:math';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/feature/stat/model/stat_model.dart';

class StatUtils {
  static StatCalulatedType calculate(List<BPRecord> records) {
    if (records.isEmpty) {
      final emptyValue = '- / -';
      return StatCalulatedType(
        avgBP: emptyValue,
        sd: emptyValue,
        maxBP: emptyValue,
        minBP: emptyValue,
      );
    }

    final summary = computeBaseMetrics(records);
    final sd = calculateStandardDeviation(records, summary.avgSys);

    return StatCalulatedType(
      avgBP: "${summary.avgSys} / ${summary.avgDia}",
      sd: "± ${sd.toStringAsFixed(1)}",
      maxBP: "${summary.max.sys} / ${summary.max.dia}",
      minBP: "${summary.min.sys} / ${summary.min.dia}",
      maxBPDate: summary.max.createdAt,
      minBPDate: summary.min.createdAt,
    );
  }

  static StatSummary computeBaseMetrics(List<BPRecord> records) {
    int sumSys = 0;
    int sumDia = 0;
    BPRecord min = records.first;
    BPRecord max = records.first;

    for (final r in records) {
      sumSys += r.sys;
      sumDia += r.dia;
      if (r.sys < min.sys) min = r;
      if (r.sys > max.sys) max = r;
    }

    return StatSummary(
      avgSys: (sumSys / records.length).round(),
      avgDia: (sumDia / records.length).round(),
      min: min,
      max: max,
    );
  }

  static double calculateStandardDeviation(List<BPRecord> records, int avgSys) {
    if (records.length <= 1) return 0.0;

    double sumSquaredDiff = 0;
    for (final r in records) {
      sumSquaredDiff += pow(r.sys - avgSys, 2);
    }
    return sqrt(sumSquaredDiff / records.length);
  }
}
