import 'package:equatable/equatable.dart';

class DoctorEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String specialization;
  final String? subspecialization;
  final String? qualification;
  final int experienceYears;
  final String? bio;
  final String? profilePicture;
  final double rating;
  final int reviewCount;
  final String? hospitalName;
  final String? hospitalAddress;
  final double consultationFee;
  final bool isAvailable;
  final List<String> availableDays;
  final String? startTime;
  final String? endTime;

  const DoctorEntity({
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
    this.rating = 0.0,
    this.reviewCount = 0,
    this.hospitalName,
    this.hospitalAddress,
    required this.consultationFee,
    this.isAvailable = true,
    this.availableDays = const [],
    this.startTime,
    this.endTime,
  });

  @override
  List<Object?> get props => [
    id, firstName, lastName, fullName, email, phoneNumber,
    specialization, subspecialization, qualification, experienceYears,
    bio, profilePicture, rating, reviewCount, hospitalName,
    hospitalAddress, consultationFee, isAvailable, availableDays,
    startTime, endTime,
  ];
}
