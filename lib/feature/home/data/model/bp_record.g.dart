// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bp_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BPRecordAdapter extends TypeAdapter<BPRecord> {
  @override
  final int typeId = 1;

  @override
  BPRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BPRecord(
      id: fields[0] as String,
      ownerId: fields[1] as String,
      sys: fields[2] as int,
      dia: fields[3] as int,
      pulse: fields[4] as int,
      createdAt: fields[5] as DateTime,
      isSynced: fields[6] as bool,
      note: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BPRecord obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ownerId)
      ..writeByte(2)
      ..write(obj.sys)
      ..writeByte(3)
      ..write(obj.dia)
      ..writeByte(4)
      ..write(obj.pulse)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.isSynced)
      ..writeByte(7)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BPRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
