
import 'package:equatable/equatable.dart';

class AuthEnitity extends Equatable{
  final String? authId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String userName;
  final String? password;
  final String? profilePicture;
  const AuthEnitity({
    this.authId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.userName,
    this.password,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [authId, fullName, email, phoneNumber, userName, password, profilePicture];
}