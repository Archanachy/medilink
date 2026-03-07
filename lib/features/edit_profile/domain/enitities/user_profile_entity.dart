import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String? userId;
  final String? patientId;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String userName;
  final String? role;
  final String? phoneNumber;
  final String? profilePicture;
  final String? dateOfBirth;
  final String? bloodGroup;
  final String? gender;
  final String? address;
  
  // Patient-specific fields
  final String? emergencyContact;
  
  // Doctor-specific fields
  final String? specialization;
  final String? qualifications;
  final int? experience;
  final double? consultationFee;
  final String? bio;

  const UserProfileEntity({
    this.userId,
    this.patientId,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    required this.userName,
    this.role,
    this.phoneNumber,
    this.profilePicture,
    this.dateOfBirth,
    this.bloodGroup,
    this.gender,
    this.address,
    this.emergencyContact,
    this.specialization,
    this.qualifications,
    this.experience,
    this.consultationFee,
    this.bio,
  });

  UserProfileEntity copyWith({
    String? userId,
    String? patientId,
    String? firstName,
    String? lastName,
    String? fullName,
    String? email,
    String? userName,
    String? role,
    String? phoneNumber,
    String? profilePicture,
    String? dateOfBirth,
    String? bloodGroup,
    String? gender,
    String? address,
    String? emergencyContact,
    String? specialization,
    String? qualifications,
    int? experience,
    double? consultationFee,
    String? bio,
  }) {
    return UserProfileEntity(
      userId: userId ?? this.userId,
      patientId: patientId ?? this.patientId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      specialization: specialization ?? this.specialization,
      qualifications: qualifications ?? this.qualifications,
      experience: experience ?? this.experience,
      consultationFee: consultationFee ?? this.consultationFee,
      bio: bio ?? this.bio,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        patientId,
        firstName,
        lastName,
        fullName,
        email,
        userName,
        role,
        phoneNumber,
        profilePicture,
        dateOfBirth,
        bloodGroup,
        gender,
        address,
        emergencyContact,
        specialization,
        qualifications,
        experience,
        consultationFee,
        bio,
      ];
}
