import 'package:dun_diary_app/data/analyze_record/datasource/analyze_local_source.dart';
import 'package:dun_diary_app/data/analyze_record/datasource/analyze_remote_source.dart';
import 'package:dun_diary_app/data/analyze_record/model/analyze_cache_model.dart';
import 'package:dun_diary_app/data/analyze_record/model/analyze_summary_model.dart';

class AnalyzeRepository {
  final AnalyzeLocalDataSource _localDataSource;
  final AnalyzeRemoteDataSource _remoteDataSource;

  AnalyzeRepository(this._localDataSource, this._remoteDataSource);

  AnalysisCache? getCachedAnalysis(String key) {
    return _localDataSource.getCache(key);
  }

  /// ยิง AI วิเคราะห์ด้วย summary แล้ว Save ลง Cache
  Future<AnalysisCache> analyzeAndSave({
    required String key,
    required AnalyzeSummary summary,
    required String signature,
  }) async {
    final aiResult = await _remoteDataSource.fetchAnalysisFromAi(summary);

    final newCache = AnalysisCache(
      content: aiResult,
      analyzedAt: DateTime.now(),
      rangeKey: key,
      dataSignature: signature,
    );

    await _localDataSource.saveCache(newCache);

    return newCache;
  }
}
