import 'package:dun_diary_app/core/constant/hive_constants.dart';
import 'package:dun_diary_app/data/analyze_record/model/analyze_cache_model.dart';
import 'package:hive_flutter/adapters.dart';

class AnalyzeLocalDataSource {
  final Box<AnalysisCache> _box;

  AnalyzeLocalDataSource()
    : _box = Hive.box<AnalysisCache>(HiveBoxName.analysisCacheBox);

  AnalysisCache? getCache(String key) {
    return _box.get(key);
  }

  Future<void> saveCache(AnalysisCache cache) async {
    await _box.put(cache.rangeKey, cache);
  }
}
