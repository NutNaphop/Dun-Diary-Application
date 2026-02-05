import 'package:dun_diary_app/core/network/network_client.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';

class AnalyzeRemoteDataSource {
  final NetworkClient _networkClient;

  AnalyzeRemoteDataSource(this._networkClient);

  Future<String> fetchAnalysisFromAi(List<BPRecord> records) async {
    final prompt = _generatePrompt(records);
    print("🚀 Sending Prompt to AI: \n$prompt");
    // 2. ยิง API
    await Future.delayed(const Duration(seconds: 2));

    // final response = await _networkClient.post(
    //   '/analyze',
    //   body: {"prompt": prompt},
    // );
    // return response.data['result'];
    return """
จากการวิเคราะห์ข้อมูลความดันในช่วงที่ผ่านมา:
- ค่าเฉลี่ยของคุณอยู่ที่ 125/82 ซึ่งถือว่า **ปกติ** - มีบางวันที่ค่า Sys สูงขึ้นเล็กน้อย (135) อาจเกิดจากการพักผ่อนน้อย
แนะนำให้ลดของเค็มและดื่มน้ำให้มากขึ้นครับ 💪
    """
        .trim();
  }

  String _generatePrompt(List<BPRecord> records) {
    if (records.isEmpty) return "ไม่มีข้อมูล";

    final buffer = StringBuffer();
    buffer.writeln(
      "ช่วยวิเคราะห์สุขภาพความดันโลหิตของฉันหน่อย ข้อมูลมีดังนี้:",
    );

    for (var i = 0; i < records.length; i++) {
      final r = records[i];
      final dateStr = "${r.createdAt.day}/${r.createdAt.month}";
      buffer.writeln(
        "- วันที่ $dateStr: ความดัน ${r.sys}/${r.dia}, ชีพจร ${r.pulse}",
      );
    }

    buffer.writeln(
      "\nขอคำแนะนำสั้นๆ กระชับ และเป็นกันเอง (ไม่เกิน 3-4 บรรทัด)",
    );
    return buffer.toString();
  }
}
