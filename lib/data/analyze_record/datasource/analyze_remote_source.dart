import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/network/network_client.dart';
import 'package:dun_diary_app/data/analyze_record/model/analyze_result_model.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';

class AnalyzeRemoteDataSource {
  final NetworkClient _networkClient;
  final AuthService _authService;

  AnalyzeRemoteDataSource(this._networkClient, this._authService);

  Future<AnalyzeResultModel> fetchAnalysisFromAi(List<BPRecord> records) async {
    final recordsJson = records.map((r) {
      return {
        "sys": r.sys,
        "dia": r.dia,
        "pulse": r.pulse,
        "date": '${r.createdAt.toUtc().toIso8601String().split('.').first}Z',
      };
    }).toList();

    final token = await _authService.getUserToken();
    if (token == null) throw Exception("Authentication required");

    try {
      final response = await _networkClient.post(
        'pressure/analyze',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {"records": recordsJson},
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response['success'] == true) {
          final data = response['data']['analysis']; // เจาะเข้าไปข้างใน
          return AnalyzeResultModel.fromJson(data);
        } else {
          throw Exception("API Error: Success is false");
        }
      }
      throw Exception("API Error: Response is null");
    } catch (e) {
      print("API Error: $e");
      rethrow;
    }
  }
}
