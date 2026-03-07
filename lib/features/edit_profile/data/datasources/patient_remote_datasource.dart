import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/core/api/api_endpoints.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/edit_profile/data/models/patient_api_model.dart';

final patientRemoteDatasourceProvider = Provider<PatientRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return PatientRemoteDatasource(apiClient, userSessionService);
});

class PatientRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  PatientRemoteDatasource(this._apiClient, this._userSessionService);

  PatientApiModel _parsePatientPayload(dynamic payload) {
    final data = payload is Map<String, dynamic> && payload.containsKey('data')
        ? payload['data']
        : payload;

    if (data is List) {
      if (data.isEmpty) {
        throw Exception('No patient found for user');
      }
      return PatientApiModel.fromJson(data.first as Map<String, dynamic>);
    }

    return PatientApiModel.fromJson(data as Map<String, dynamic>);
  }

  bool _isRouteNotFound(DioException exception) {
    final message = exception.response?.data is Map<String, dynamic>
        ? exception.response?.data['message']?.toString().toLowerCase()
        : null;
    return exception.response?.statusCode == 404 &&
        (message?.contains('route not found') ?? false);
  }

  PatientApiModel _patientFromUserData(Map<String, dynamic> userData, String userId) {
    final fullName = (userData['name'] as String?)?.trim();
    final firstNameFromName = fullName != null && fullName.isNotEmpty
        ? fullName.split(' ').first
        : null;
    final lastNameFromName = fullName != null && fullName.split(' ').length > 1
        ? fullName.split(' ').sublist(1).join(' ')
        : null;

    return PatientApiModel(
      id: userData['_id'] as String? ?? userData['id'] as String?,
      userId: userId,
      firstName: userData['firstName'] as String? ?? firstNameFromName ?? '',
      lastName: userData['lastName'] as String? ?? lastNameFromName ?? '',
      phone: userData['phone'] as String? ?? userData['phoneNumber'] as String?,
      dateOfBirth: userData['dateOfBirth'] as String?,
      gender: userData['gender'] as String?,
      bloodGroup: userData['bloodGroup'] as String?,
      address: userData['address'] as String?,
      profileImage: userData['profileImage'] as String? ?? userData['profilePicture'] as String?,
    );
  }

  PatientApiModel _patientFromSession(String userId) {
    final fullName = _userSessionService.getCurrentUserFullName() ?? '';
    final nameParts = fullName.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    return PatientApiModel(
      id: _userSessionService.getCurrentPatientId(),
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      phone: _userSessionService.getCurrentUserPhoneNumber(),
      profileImage: _userSessionService.getCurrentUserProfilePicture(),
    );
  }

  Future<PatientApiModel> getPatientByUserId(String userId) async {
    try {
      final res = await _apiClient.get(ApiEndpoints.patientByUserId(userId));
      return _parsePatientPayload(res.data);
    } on DioException catch (e) {
      if (!_isRouteNotFound(e)) {
        rethrow;
      }

      try {
        final listRes = await _apiClient.get(
          ApiEndpoints.patients,
          queryParameters: {'userId': userId},
        );
        return _parsePatientPayload(listRes.data);
      } on DioException {
        try {
          final profileRes = await _apiClient.get('/api/patient/profile');
          final profileData = profileRes.data is Map<String, dynamic>
              ? (profileRes.data['data'] ?? profileRes.data) as Map<String, dynamic>
              : <String, dynamic>{};
          return _patientFromUserData(profileData, userId);
        } on DioException {
          try {
            final meRes = await _apiClient.get('/api/auth/me');
            final meData = meRes.data is Map<String, dynamic>
                ? (meRes.data['data'] ?? meRes.data) as Map<String, dynamic>
                : <String, dynamic>{};
            return _patientFromUserData(meData, userId);
          } on DioException {
            return _patientFromSession(userId);
          }
        }
      }
    }
  }

  Future<PatientApiModel> updatePatient({
    required String patientId,
    required PatientApiModel payload,
    File? profileImage,
  }) async {
    Response res;
    if (profileImage != null) {
      final formData = FormData.fromMap({
        ...payload.toJson(),
        'profileImage': await MultipartFile.fromFile(profileImage.path),
      });
      res = await _apiClient.put(
        ApiEndpoints.patientById(patientId),
        data: formData,
      );
    } else {
      res = await _apiClient.put(
        ApiEndpoints.patientById(patientId),
        data: payload.toJson(),
      );
    }

    final data = res.data['data'] ?? res.data;
    
    // Handle if backend returns array instead of single object
    if (data is List) {
      if (data.isEmpty) {
        throw Exception('No patient found after update');
      }
      return PatientApiModel.fromJson(data.first as Map<String, dynamic>);
    }
    
    return PatientApiModel.fromJson(data as Map<String, dynamic>);
  }
}
