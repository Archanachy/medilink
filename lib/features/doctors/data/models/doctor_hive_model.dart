import 'package:hive/hive.dart';
import 'package:medilink/core/constants/hive_table_constant.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_entity.dart';

part 'doctor_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.doctorTypeId)
class DoctorHiveModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String firstName;
  @HiveField(2)
  final String lastName;
  @HiveField(3)
  final String fullName;
  @HiveField(4)
  final String email;
  @HiveField(5)
  final String? phoneNumber;
  @HiveField(6)
  final String specialization;
  @HiveField(7)
  final String? subspecialization;
  @HiveField(8)
  final String? qualification;
  @HiveField(9)
  final int experienceYears;
  @HiveField(10)
  final String? bio;
  @HiveField(11)
  final String? profilePicture;
  @HiveField(12)
  final double rating;
  @HiveField(13)
  final int reviewCount;
  @HiveField(14)
  final String? hospitalName;
  @HiveField(15)
  final String? hospitalAddress;
  @HiveField(16)
  final double consultationFee;
  @HiveField(17)
  final bool isAvailable;
  @HiveField(18)
  final List<String> availableDays;
  @HiveField(19)
  final String? startTime;
  @HiveField(20)
  final String? endTime;

  DoctorHiveModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.specialization,
    this.subspecialization,
    this.qualification,
    required this.experienceYears,
    this.bio,
    this.profilePicture,
    required this.rating,
    required this.reviewCount,
    this.hospitalName,
    this.hospitalAddress,
    required this.consultationFee,
    required this.isAvailable,
    required this.availableDays,
    this.startTime,
    this.endTime,
  });

  factory DoctorHiveModel.fromEntity(DoctorEntity entity) {
    return DoctorHiveModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      specialization: entity.specialization,
      subspecialization: entity.subspecialization,
      qualification: entity.qualification,
      experienceYears: entity.experienceYears,
      bio: entity.bio,
      profilePicture: entity.profilePicture,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      hospitalName: entity.hospitalName,
      hospitalAddress: entity.hospitalAddress,
      consultationFee: entity.consultationFee,
      isAvailable: entity.isAvailable,
      availableDays: entity.availableDays,
      startTime: entity.startTime,
      endTime: entity.endTime,
    );
  }

  DoctorEntity toEntity() {
    return DoctorEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      specialization: specialization,
      subspecialization: subspecialization,
      qualification: qualification,
      experienceYears: experienceYears,
      bio: bio,
      profilePicture: profilePicture,
      rating: rating,
      reviewCount: reviewCount,
      hospitalName: hospitalName,
      hospitalAddress: hospitalAddress,
      consultationFee: consultationFee,
      isAvailable: isAvailable,
      availableDays: availableDays,
      startTime: startTime,
      endTime: endTime,
    );
  }
}
