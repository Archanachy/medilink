import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/core/api/api_endpoints.dart';
import 'package:medilink/features/specializations/data/models/specialization_api_model.dart';

class SpecializationRemoteDataSource {
  final ApiClient _apiClient;

  SpecializationRemoteDataSource(this._apiClient);

  Future<List<SpecializationApiModel>> getSpecializations() async {
    final response = await _apiClient.get(ApiEndpoints.specializations);

    if (response.data is Map && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((json) => SpecializationApiModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  Future<SpecializationApiModel> getSpecializationById(String id) async {
    final response = await _apiClient.get(
      ApiEndpoints.specializationById(id),
    );

    return SpecializationApiModel.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }
}
