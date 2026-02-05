// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analyze_result_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnalyzeResultModelAdapter extends TypeAdapter<AnalyzeResultModel> {
  @override
  final int typeId = 3;

  @override
  AnalyzeResultModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalyzeResultModel(
      summary: fields[0] as String,
      riskLevel: fields[1] as String,
      suggestions: (fields[2] as List).cast<String>(),
      reference: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AnalyzeResultModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.summary)
      ..writeByte(1)
      ..write(obj.riskLevel)
      ..writeByte(2)
      ..write(obj.suggestions)
      ..writeByte(3)
      ..write(obj.reference);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyzeResultModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
