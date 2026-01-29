import 'package:medilink/core/api/api_endpoints.dart';
import 'package:medilink/features/edit_profile/domain/enitities/user_profile_entity.dart';

class PatientApiModel {
  final String? id; // patientId
  final String userId;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? dateOfBirth;
  final String? gender;
  final String? bloodGroup;
  final String? address;
  final String? profileImage;

  PatientApiModel({
    this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.address,
    this.profileImage,
  });

  factory PatientApiModel.fromJson(Map<String, dynamic> json) {
    return PatientApiModel(
      id: json['_id'] as String?,
      userId: (json['userId'] as String?) ?? '',
      firstName: (json['firstName'] as String?) ?? '',
      lastName: (json['lastName'] as String?) ?? '',
      phone: json['phone'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      gender: json['gender'] as String?,
      bloodGroup: json['bloodGroup'] as String?,
      address: json['address'] as String?,
      profileImage: json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'firstName': firstName,
      'lastName': lastName,
    };

    void addIfNotEmpty(String key, String? value) {
      if (value != null && value.isNotEmpty) {
        data[key] = value;
      }
    }

    addIfNotEmpty('phone', phone);
    addIfNotEmpty('dateOfBirth', dateOfBirth);
    addIfNotEmpty('gender', gender);
    addIfNotEmpty('bloodGroup', bloodGroup);
    addIfNotEmpty('address', address);

    return data;
  }

  UserProfileEntity toEntity({required String email, required String userName}) {
    String? _resolveImageUrl(String? path) {
      if (path == null || path.isEmpty) return null;
      if (path.startsWith('http')) return path;
      return '${ApiEndpoints.baseUrl}$path';
    }

    return UserProfileEntity(
      userId: userId,
      patientId: id,
      firstName: firstName,
      lastName: lastName,
      fullName: '$firstName $lastName'.trim(),
      email: email,
      userName: userName,
      phoneNumber: phone,
      profilePicture: _resolveImageUrl(profileImage),
      dateOfBirth: dateOfBirth,
      bloodGroup: bloodGroup,
      gender: gender,
      address: address,
    );
  }
}
