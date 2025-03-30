// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthAdapter extends TypeAdapter<Health> {
  @override
  final int typeId = 2;

  @override
  Health read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Health(
      isMale: fields[0] as bool,
      age: fields[1] as int,
      allergies: (fields[2] as List?)?.cast<String>(),
      diseases: (fields[3] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Health obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.isMale)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(2)
      ..write(obj.allergies)
      ..writeByte(3)
      ..write(obj.diseases);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
