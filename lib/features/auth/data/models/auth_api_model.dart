import 'package:medilink/features/auth/domain/enitities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? password;
  final String? profilePicture;

  AuthApiModel({
    this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.password,
    this.profilePicture,
  });

  // Getter to derive userName from email
  String get userName => email.split('@')[0];

  // toJSON
  Map<String, dynamic> toJson() {
    final names = fullName.split(' ');
    return {
      "firstName": names.isNotEmpty ? names[0] : "",
      "lastName": names.length > 1 ? names.sublist(1).join(' ') : "",
      "email": email,
      "phoneNumber": phoneNumber ?? "",
      "username": userName,
      "password": password,
      "profilePicture": profilePicture ?? "",
      "confirmPassword": password,
    };
  }

  // fromJson
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName'] as String? ?? '';
    final lastName = json['lastName'] as String? ?? '';
    final fullName = '$firstName $lastName'.trim();

    return AuthApiModel(
      id: json['_id'] as String?,
      fullName: fullName.isEmpty ? json['username'] as String : fullName,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profilePicture: json['profilePicture'] as String?,
    );
  }

  // toEntity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      userName: userName,
      profilePicture: profilePicture,
    );
  }

  // fromEntity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      password: entity.password,
      profilePicture: entity.profilePicture,
    );
  }

  // toEntityList
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}