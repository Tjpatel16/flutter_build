// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectHistoryAdapter extends TypeAdapter<ProjectHistory> {
  @override
  final int typeId = 0;

  @override
  ProjectHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectHistory(
      path: fields[0] as String,
      name: fields[1] as String,
      lastAccessed: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ProjectHistory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.lastAccessed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
