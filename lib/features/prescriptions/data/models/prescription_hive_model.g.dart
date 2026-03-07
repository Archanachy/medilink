// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrescriptionHiveModelAdapter extends TypeAdapter<PrescriptionHiveModel> {
  @override
  final int typeId = 10;

  @override
  PrescriptionHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrescriptionHiveModel(
      id: fields[0] as String,
      patientId: fields[1] as String,
      doctorId: fields[2] as String,
      doctorName: fields[3] as String,
      medications: (fields[4] as List).cast<MedicationHiveModel>(),
      diagnosis: fields[5] as String?,
      notes: fields[6] as String?,
      date: fields[7] as DateTime,
      status: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PrescriptionHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.patientId)
      ..writeByte(2)
      ..write(obj.doctorId)
      ..writeByte(3)
      ..write(obj.doctorName)
      ..writeByte(4)
      ..write(obj.medications)
      ..writeByte(5)
      ..write(obj.diagnosis)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.date)
      ..writeByte(8)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrescriptionHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MedicationHiveModelAdapter extends TypeAdapter<MedicationHiveModel> {
  @override
  final int typeId = 11;

  @override
  MedicationHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicationHiveModel(
      name: fields[0] as String,
      dosage: fields[1] as String,
      frequency: fields[2] as String,
      duration: fields[3] as String,
      instructions: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MedicationHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.dosage)
      ..writeByte(2)
      ..write(obj.frequency)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.instructions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
