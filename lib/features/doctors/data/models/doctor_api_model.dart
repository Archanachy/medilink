import 'package:medilink/features/doctors/domain/entities/doctor_entity.dart';

class DoctorApiModel {
  final String id;
  final String firstName;
  final String lastName;
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

  DoctorApiModel({
    required this.id,
    required this.firstName,
    required this.lastName,
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

  factory DoctorApiModel.fromJson(Map<String, dynamic> json) {
    return DoctorApiModel(
      id: json['_id'] as String? ?? json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      specialization: json['specialization'] as String,
      subspecialization: json['subspecialization'] as String?,
      qualification: json['qualification'] as String?,
      experienceYears: json['experienceYears'] as int? ?? 0,
      bio: json['bio'] as String?,
      profilePicture: json['profilePicture'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      hospitalName: json['hospitalName'] as String?,
      hospitalAddress: json['hospitalAddress'] as String?,
      consultationFee: (json['consultationFee'] as num?)?.toDouble() ?? 0.0,
      isAvailable: json['isAvailable'] as bool? ?? true,
      availableDays: (json['availableDays'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'specialization': specialization,
      'subspecialization': subspecialization,
      'qualification': qualification,
      'experienceYears': experienceYears,
      'bio': bio,
      'profilePicture': profilePicture,
      'rating': rating,
      'reviewCount': reviewCount,
      'hospitalName': hospitalName,
      'hospitalAddress': hospitalAddress,
      'consultationFee': consultationFee,
      'isAvailable': isAvailable,
      'availableDays': availableDays,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  DoctorEntity toEntity() {
    return DoctorEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      fullName: '$firstName $lastName',
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

  static List<DoctorEntity> toEntityList(List<DoctorApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
