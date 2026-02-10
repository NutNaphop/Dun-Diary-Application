import 'package:dun_diary_app/core/constant/hive_constants.dart';
import 'package:dun_diary_app/data/analyze_record/model/analyze_cache_model.dart';
import 'package:hive_flutter/adapters.dart';

/// Local Data Source สำหรับจัดการ AI Analysis Cache
///
/// เก็บผลการวิเคราะห์จาก AI ไว้ใน Hive
/// เพื่อไม่ต้องเรียก API ซ้ำถ้าข้อมูลไม่เปลี่ยน
///
/// Cache Key Format: "week_2024_5", "month_2024_2", "year_2024"
class AnalyzeLocalDataSource {
  /// Box เก็บ AnalysisCache (key = rangeKey)
  final Box<AnalysisCache> _box;

  AnalyzeLocalDataSource()
    : _box = Hive.box<AnalysisCache>(HiveBoxName.analysisCacheBox);

  /// ดึง Cache ตาม key (null ถ้าไม่มี)
  AnalysisCache? getCache(String key) {
    return _box.get(key);
  }

  /// บันทึก Cache (overwrite ถ้า key ซ้ำ)
  Future<void> saveCache(AnalysisCache cache) async {
    await _box.put(cache.rangeKey, cache);
  }
}
