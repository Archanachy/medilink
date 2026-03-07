// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentHiveModelAdapter extends TypeAdapter<AppointmentHiveModel> {
  @override
  final int typeId = 2;

  @override
  AppointmentHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppointmentHiveModel(
      id: fields[0] as String,
      patientId: fields[1] as String,
      doctorId: fields[2] as String,
      patientName: fields[3] as String,
      doctorName: fields[4] as String,
      appointmentDate: fields[5] as DateTime,
      startTime: fields[6] as String,
      endTime: fields[7] as String,
      status: fields[8] as String,
      reason: fields[9] as String?,
      location: fields[10] as String?,
      consultationFee: fields[11] as double,
      createdAt: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AppointmentHiveModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.patientId)
      ..writeByte(2)
      ..write(obj.doctorId)
      ..writeByte(3)
      ..write(obj.patientName)
      ..writeByte(4)
      ..write(obj.doctorName)
      ..writeByte(5)
      ..write(obj.appointmentDate)
      ..writeByte(6)
      ..write(obj.startTime)
      ..writeByte(7)
      ..write(obj.endTime)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.reason)
      ..writeByte(10)
      ..write(obj.location)
      ..writeByte(11)
      ..write(obj.consultationFee)
      ..writeByte(12)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
