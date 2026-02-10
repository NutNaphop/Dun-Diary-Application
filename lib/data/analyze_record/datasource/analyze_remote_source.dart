import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/network/network_client.dart';
import 'package:dun_diary_app/data/analyze_record/model/analyze_result_model.dart';
import 'package:dun_diary_app/data/analyze_record/model/analyze_summary_model.dart';

class AnalyzeRemoteDataSource {
  final NetworkClient _networkClient;
  final AuthService _authService;

  AnalyzeRemoteDataSource(this._networkClient, this._authService);

  /// ส่ง summary ไป AI วิเคราะห์
  ///
  /// [summary] - ข้อมูลสรุปที่จะส่งไป (แทน raw records)
  Future<AnalyzeResultModel> fetchAnalysisFromAi(AnalyzeSummary summary) async {
    final token = await _authService.getUserToken();

    try {
      final response = await _networkClient.post(
        'pressure/analyze',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: summary.toJson(),
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response['success'] == true) {
          final data = response['data']['analysis'];
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
