import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/core/api/api_endpoints.dart';
import 'package:medilink/features/edit_profile/data/models/patient_api_model.dart';

final patientRemoteDatasourceProvider = Provider<PatientRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return PatientRemoteDatasource(apiClient);
});

class PatientRemoteDatasource {
  final ApiClient _apiClient;

  PatientRemoteDatasource(this._apiClient);

  Future<PatientApiModel> getPatientByUserId(String userId) async {
    final res = await _apiClient.get(ApiEndpoints.patientByUserId(userId));
    final data = res.data['data'] ?? res.data;
    return PatientApiModel.fromJson(data as Map<String, dynamic>);
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
    return PatientApiModel.fromJson(data as Map<String, dynamic>);
  }
}
