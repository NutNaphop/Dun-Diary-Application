import 'package:hive/hive.dart';

part 'analyze_result_model.g.dart'; // เดี๋ยวต้องรัน build_runner

@HiveType(
  typeId: 3,
) // ⚠️ เช็คว่า typeId 2 ยังว่างอยู่ไหม (ถ้าไม่ว่างให้เปลี่ยนเลข)
class AnalyzeResultModel {
  @HiveField(0)
  final String summary;

  @HiveField(1)
  final String riskLevel; // รับมาเป็น "1", "2", "3"

  @HiveField(2)
  final List<String> suggestions;

  @HiveField(3)
  final String reference;

  AnalyzeResultModel({
    required this.summary,
    required this.riskLevel,
    required this.suggestions,
    required this.reference,
  });

  // Factory สำหรับแปลง JSON จาก Backend
  factory AnalyzeResultModel.fromJson(Map<String, dynamic> json) {
    // Handle risk_level ที่อาจมาเป็น int หรือ String
    final riskLevelRaw = json['risk_level'];
    final riskLevel = riskLevelRaw?.toString() ?? '0';

    return AnalyzeResultModel(
      summary: json['summary'] ?? '',
      riskLevel: riskLevel,
      suggestions: List<String>.from(json['suggest'] ?? []),
      reference: json['reference'] ?? '',
    );
  }

  // แปลงกลับเป็น JSON (เผื่อใช้)
  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'risk_level': riskLevel,
      'suggest': suggestions,
      'reference': reference,
    };
  }
}

class AnalyzeResponse {
  final String summary;
  final String riskLevel;
  final List<String> suggestions;
  final String reference;

  AnalyzeResponse({
    required this.summary,
    required this.riskLevel,
    required this.suggestions,
    required this.reference,
  });
}
