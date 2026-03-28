import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';

class AnalyzeUtils {
  static String generateDataSignature(List<BPRecord> records) {
    if (records.isEmpty) return "0_0_0_0_0";

    int sumSys = 0;
    int sumDia = 0;
    int sumPulse = 0;

    int lastTimestamp = records.last.createdAt.millisecondsSinceEpoch;

    for (var record in records) {
      sumSys += record.sys;
      sumDia += record.dia;
      sumPulse += record.pulse;
    }
    return "${records.length}_${sumSys}_${sumDia}_${sumPulse}_${lastTimestamp}";
  }
}
