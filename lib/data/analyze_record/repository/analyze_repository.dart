import 'package:dun_diary_app/data/analyze_record/datasource/analyze_local_source.dart';
import 'package:dun_diary_app/data/analyze_record/datasource/analyze_remote_source.dart';
import 'package:dun_diary_app/data/analyze_record/model/analyze_cache_model.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';

class AnalyzeRepository {
  final AnalyzeLocalDataSource _localDataSource;
  final AnalyzeRemoteDataSource _remoteDataSource;

  AnalyzeRepository(this._localDataSource, this._remoteDataSource);

  AnalysisCache? getCachedAnalysis(String key) {
    return _localDataSource.getCache(key);
  }

  // 2. ยิง AI แล้ว Save ลง Cache (ใช้ Remote + Local)
  Future<AnalysisCache> analyzeAndSave({
    required String key,
    required List<BPRecord> records,
    required String signature,
  }) async {
    final aiResult = await _remoteDataSource.fetchAnalysisFromAi(records);

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
