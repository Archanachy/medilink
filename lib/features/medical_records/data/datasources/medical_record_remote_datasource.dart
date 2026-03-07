import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/core/api/api_endpoints.dart';
import 'package:medilink/features/medical_records/data/models/medical_record_api_model.dart';

final medicalRecordRemoteDatasourceProvider =
    Provider<MedicalRecordRemoteDatasource>((ref) {
  return MedicalRecordRemoteDatasource(ref.read(apiClientProvider));
});

class MedicalRecordRemoteDatasource {
  final ApiClient _apiClient;

  MedicalRecordRemoteDatasource(this._apiClient);

  Future<MedicalRecordApiModel> uploadRecord({
    required String patientId,
    String? doctorId,
    required String title,
    required String type,
    required String filePath,
    String? notes,
  }) async {
    final file = File(filePath);
    final fileName = file.path.split('/').last;

    final formData = FormData.fromMap({
      'patientId': patientId,
      'doctorId': doctorId,
      'title': title,
      'description': notes,
      'report': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    final response = await _apiClient.post(
      ApiEndpoints.records,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return MedicalRecordApiModel.fromJson(data);
  }

  Future<List<MedicalRecordApiModel>> getRecords({
    required String patientId,
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, dynamic>{'patientId': patientId};
    if (page != null) queryParams['page'] = page;
    if (limit != null) queryParams['limit'] = limit;

    final response = await _apiClient.get(
      ApiEndpoints.records,
      queryParameters: queryParams,
    );

    final data = response.data['data'] as List<dynamic>;
    return data
        .map((json) =>
            MedicalRecordApiModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
