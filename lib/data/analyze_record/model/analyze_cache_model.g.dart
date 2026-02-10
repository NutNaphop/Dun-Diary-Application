// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analyze_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnalysisCacheAdapter extends TypeAdapter<AnalysisCache> {
  @override
  final int typeId = 2;

  @override
  AnalysisCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalysisCache(
      content: fields[0] as AnalyzeResultModel,
      analyzedAt: fields[1] as DateTime,
      rangeKey: fields[2] as String,
      dataSignature: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AnalysisCache obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.content)
      ..writeByte(1)
      ..write(obj.analyzedAt)
      ..writeByte(2)
      ..write(obj.rangeKey)
      ..writeByte(3)
      ..write(obj.dataSignature);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalysisCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
