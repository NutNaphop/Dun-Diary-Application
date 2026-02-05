import 'package:hive/hive.dart';

part 'analyze_cache_model.g.dart';

@HiveType(typeId: 2)
class AnalysisCache extends HiveObject {
  @HiveField(0)
  final String content;

  @HiveField(1)
  final DateTime analyzedAt;

  @HiveField(2)
  final String rangeKey;

  @HiveField(3) 
  final String dataSignature; 

  AnalysisCache({
    required this.content,
    required this.analyzedAt,
    required this.rangeKey,
    required this.dataSignature,
  });
}
