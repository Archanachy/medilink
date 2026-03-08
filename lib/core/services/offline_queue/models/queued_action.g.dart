// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queued_action.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QueuedActionAdapter extends TypeAdapter<QueuedAction> {
  @override
  final int typeId = 15;

  @override
  QueuedAction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QueuedAction(
      id: fields[0] as String,
      actionType: fields[1] as String,
      endpoint: fields[2] as String,
      data: (fields[3] as Map).cast<String, dynamic>(),
      createdAt: fields[4] as DateTime,
      status: fields[5] as String,
      retryCount: fields[6] as int,
      errorMessage: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, QueuedAction obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.actionType)
      ..writeByte(2)
      ..write(obj.endpoint)
      ..writeByte(3)
      ..write(obj.data)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.retryCount)
      ..writeByte(7)
      ..write(obj.errorMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueuedActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
