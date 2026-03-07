
import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String userName;
  final String? password;
  final String? confirmPassword;
  final String? profilePicture;
  final bool isEmailVerified;
  final String? role;
  final DateTime? createdAt;
  
  const AuthEntity({
    this.authId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.userName,
    this.password,
    this.confirmPassword,
    this.profilePicture,
    this.isEmailVerified = false,
    this.role,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    authId, fullName, email, phoneNumber, userName, 
    password, confirmPassword, profilePicture, 
    isEmailVerified, role, createdAt
  ];
}