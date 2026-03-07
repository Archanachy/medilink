// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoctorHiveModelAdapter extends TypeAdapter<DoctorHiveModel> {
  @override
  final int typeId = 1;

  @override
  DoctorHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoctorHiveModel(
      id: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      fullName: fields[3] as String,
      email: fields[4] as String,
      phoneNumber: fields[5] as String?,
      specialization: fields[6] as String,
      subspecialization: fields[7] as String?,
      qualification: fields[8] as String?,
      experienceYears: fields[9] as int,
      bio: fields[10] as String?,
      profilePicture: fields[11] as String?,
      rating: fields[12] as double,
      reviewCount: fields[13] as int,
      hospitalName: fields[14] as String?,
      hospitalAddress: fields[15] as String?,
      consultationFee: fields[16] as double,
      isAvailable: fields[17] as bool,
      availableDays: (fields[18] as List).cast<String>(),
      startTime: fields[19] as String?,
      endTime: fields[20] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DoctorHiveModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.fullName)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.phoneNumber)
      ..writeByte(6)
      ..write(obj.specialization)
      ..writeByte(7)
      ..write(obj.subspecialization)
      ..writeByte(8)
      ..write(obj.qualification)
      ..writeByte(9)
      ..write(obj.experienceYears)
      ..writeByte(10)
      ..write(obj.bio)
      ..writeByte(11)
      ..write(obj.profilePicture)
      ..writeByte(12)
      ..write(obj.rating)
      ..writeByte(13)
      ..write(obj.reviewCount)
      ..writeByte(14)
      ..write(obj.hospitalName)
      ..writeByte(15)
      ..write(obj.hospitalAddress)
      ..writeByte(16)
      ..write(obj.consultationFee)
      ..writeByte(17)
      ..write(obj.isAvailable)
      ..writeByte(18)
      ..write(obj.availableDays)
      ..writeByte(19)
      ..write(obj.startTime)
      ..writeByte(20)
      ..write(obj.endTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
