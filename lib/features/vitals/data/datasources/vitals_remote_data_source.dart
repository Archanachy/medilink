import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/features/vitals/data/models/vitals_api_model.dart';

class VitalsRemoteDataSource {
  final ApiClient _apiClient;

  VitalsRemoteDataSource(this._apiClient);

  Future<List<VitalsApiModel>> getVitals({String? vitalType}) async {
    final queryParams = <String, dynamic>{};
    if (vitalType != null) {
      queryParams['type'] = vitalType;
    }

    final response = await _apiClient.get(
      '/vitals',
      queryParameters: queryParams,
    );

    return (response.data['data'] as List<dynamic>)
        .map((e) => VitalsApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<VitalsApiModel> getVitalById(String id) async {
    final response = await _apiClient.get('/vitals/$id');

    return VitalsApiModel.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  Future<VitalsApiModel> recordVital(VitalsApiModel vital) async {
    final response = await _apiClient.post(
      '/vitals',
      data: vital.toJson(),
    );

    return VitalsApiModel.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  Future<void> deleteVital(String id) async {
    await _apiClient.delete('/vitals/$id');
  }

  Future<List<VitalsApiModel>> getVitalsByDateRange(
    DateTime startDate,
    DateTime endDate, {
    String? vitalType,
  }) async {
    final queryParams = <String, dynamic>{
      'startDate': startDate.toIso8601String().split('T')[0],
      'endDate': endDate.toIso8601String().split('T')[0],
      if (vitalType != null) 'type': vitalType,
    };

    final response = await _apiClient.get(
      '/vitals/range',
      queryParameters: queryParams,
    );

    return (response.data['data'] as List<dynamic>)
        .map((e) => VitalsApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
