import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String? userId;
  final String? patientId;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String userName;
  final String? phoneNumber;
  final String? profilePicture;
  final String? dateOfBirth;
  final String? bloodGroup;
  final String? gender;
  final String? address;

  const UserProfileEntity({
    this.userId,
    this.patientId,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    required this.userName,
    this.phoneNumber,
    this.profilePicture,
    this.dateOfBirth,
    this.bloodGroup,
    this.gender,
    this.address,
  });

  UserProfileEntity copyWith({
    String? userId,
    String? patientId,
    String? firstName,
    String? lastName,
    String? fullName,
    String? email,
    String? userName,
    String? phoneNumber,
    String? profilePicture,
    String? dateOfBirth,
    String? bloodGroup,
    String? gender,
    String? address,
  }) {
    return UserProfileEntity(
      userId: userId ?? this.userId,
      patientId: patientId ?? this.patientId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      gender: gender ?? this.gender,
      address: address ?? this.address,
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
        phoneNumber,
        profilePicture,
        dateOfBirth,
        bloodGroup,
        gender,
        address,
      ];
}
