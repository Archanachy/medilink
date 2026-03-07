import 'package:medilink/features/edit_profile/domain/enitities/user_profile_entity.dart';

class UserProfileApiModel {
  final String? id;
  final String firstName;
  final String lastName;
  final String name;
  final String email;
  final String userName;
  final String? phoneNumber;
  final String? profilePicture;
  final String? dateOfBirth;
  final String? bloodGroup;
  final String? gender;
  final String? address;
  final String? role;
  final String? emergencyContact;
  // Doctor-specific fields
  final String? specialization;
  final String? qualifications;
  final int? experience;
  final double? consultationFee;
  final String? bio;

  UserProfileApiModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.email,
    required this.userName,
    this.phoneNumber,
    this.profilePicture,
    this.dateOfBirth,
    this.bloodGroup,
    this.gender,
    this.address,
    this.role,
    this.emergencyContact,
    this.specialization,
    this.qualifications,
    this.experience,
    this.consultationFee,
    this.bio,
  });

  // From JSON
  factory UserProfileApiModel.fromJson(Map<String, dynamic> json) {
    // Handle nested data structure if response contains {success: true, data: {...}}
    final data = json['data'] ?? json;

    // Support both flat and nested structures (user/patient/doctor)
    final userData = (data['user'] as Map<String, dynamic>?) ?? data;
    final patientData = (data['patient'] as Map<String, dynamic>?) ?? data;
    final doctorData = (data['doctor'] as Map<String, dynamic>?) ?? data;

    final firstName = (patientData['firstName'] as String?) ??
        (doctorData['firstName'] as String?) ??
        (userData['firstName'] as String?) ??
        '';
    final lastName = (patientData['lastName'] as String?) ??
        (doctorData['lastName'] as String?) ??
        (userData['lastName'] as String?) ??
        '';

    // Construct full name from firstName and lastName if 'name' field doesn't exist
    final name = (data['name'] as String?) ??
        (data['fullName'] as String?) ??
        '$firstName $lastName'.trim();

    final phone = (patientData['phone'] as String?) ??
        (doctorData['phone'] as String?) ??
        (userData['phone'] as String?) ??
        (patientData['phoneNumber'] as String?) ??
        (doctorData['phoneNumber'] as String?) ??
        (userData['phoneNumber'] as String?);

    final profileImage = (patientData['profileImage'] as String?) ??
        (doctorData['profileImage'] as String?) ??
        (userData['profileImage'] as String?) ??
        (patientData['profilePicture'] as String?) ??
        (doctorData['profilePicture'] as String?) ??
        (userData['profilePicture'] as String?);

    return UserProfileApiModel(
      id: (patientData['_id'] as String?) ??
          (doctorData['_id'] as String?) ??
          (userData['_id'] as String?) ??
          (data['_id'] as String?),
      firstName: firstName,
      lastName: lastName,
      name: name.isNotEmpty ? name : 'User',
      email: (userData['email'] as String?) ?? '',
      userName: (userData['userName'] as String?) ??
          (userData['username'] as String?) ??
          '',
      phoneNumber: phone,
      profilePicture: profileImage,
      dateOfBirth: (patientData['dateOfBirth'] as String?) ??
          (userData['dateOfBirth'] as String?),
      bloodGroup: (patientData['bloodGroup'] as String?) ??
          (userData['bloodGroup'] as String?),
      gender:
          (patientData['gender'] as String?) ?? (userData['gender'] as String?),
      address: (patientData['address'] as String?) ??
          (doctorData['address'] as String?) ??
          (userData['address'] as String?),
      role: (userData['role'] as String?) ?? (data['role'] as String?),
      emergencyContact: (patientData['emergencyContact'] as String?) ??
          (userData['emergencyContact'] as String?),
      // Doctor-specific fields
      specialization: (doctorData['specialization'] as String?) ??
          (userData['specialization'] as String?),
      qualifications: (doctorData['qualifications'] as String?) ??
          (userData['qualifications'] as String?),
      experience: (doctorData['experience'] as int?) ??
          (userData['experience'] as int?) ??
          (doctorData['experience'] as num?)?.toInt() ??
          (userData['experience'] as num?)?.toInt(),
      consultationFee: (doctorData['consultationFee'] as double?) ??
          (userData['consultationFee'] as double?) ??
          (doctorData['consultationFee'] as num?)?.toDouble() ??
          (userData['consultationFee'] as num?)?.toDouble(),
      bio: (doctorData['bio'] as String?) ?? (userData['bio'] as String?),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'firstName': firstName,
      'lastName': lastName,
      'name': name,
      'email': email,
      'userName': userName,
      // Provide username alias for APIs expecting this key
      'username': userName,
    };

    void addIfNotEmpty(String key, String? value) {
      if (value != null && value.isNotEmpty) {
        data[key] = value;
      }
    }

    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        data[key] = value;
      }
    }

    addIfNotEmpty('phoneNumber', phoneNumber);
    addIfNotEmpty('phone', phoneNumber); // Support backends using `phone`
    addIfNotEmpty('profilePicture', profilePicture);
    addIfNotEmpty('profileImage', profilePicture);
    addIfNotEmpty('dateOfBirth', dateOfBirth);
    addIfNotEmpty('bloodGroup', bloodGroup);
    addIfNotEmpty('gender', gender);
    addIfNotEmpty('address', address);
    addIfNotEmpty('role', role);
    addIfNotEmpty('emergencyContact', emergencyContact);
    // Doctor-specific fields
    addIfNotEmpty('specialization', specialization);
    addIfNotEmpty('qualifications', qualifications);
    addIfNotNull('experience', experience);
    addIfNotNull('consultationFee', consultationFee);
    addIfNotEmpty('bio', bio);

    return data;
  }

  // To Entity
  UserProfileEntity toEntity() {
    return UserProfileEntity(
      userId: id,
      firstName: firstName,
      lastName: lastName,
      fullName: name,
      email: email,
      userName: userName,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
      dateOfBirth: dateOfBirth,
      bloodGroup: bloodGroup,
      gender: gender,
      address: address,
      role: role,
      emergencyContact: emergencyContact,
      specialization: specialization,
      qualifications: qualifications,
      experience: experience,
      consultationFee: consultationFee,
      bio: bio,
    );
  }

  // From Entity
  factory UserProfileApiModel.fromEntity(UserProfileEntity entity) {
    return UserProfileApiModel(
      id: entity.userId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      name: entity.fullName,
      email: entity.email,
      userName: entity.userName,
      phoneNumber: entity.phoneNumber,
      profilePicture: entity.profilePicture,
      dateOfBirth: entity.dateOfBirth,
      bloodGroup: entity.bloodGroup,
      gender: entity.gender,
      address: entity.address,
      role: entity.role,
      emergencyContact: entity.emergencyContact,
      specialization: entity.specialization,
      qualifications: entity.qualifications,
      experience: entity.experience,
      consultationFee: entity.consultationFee,
      bio: entity.bio,
    );
  }
}
