import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/core/api/api_endpoints.dart';
import 'package:medilink/features/doctors/data/models/doctor_api_model.dart';

final doctorRemoteDataSourceProvider = Provider<DoctorRemoteDataSource>((ref) {
  return DoctorRemoteDataSource(ref.read(apiClientProvider));
});

class DoctorRemoteDataSource {
  final ApiClient _apiClient;

  DoctorRemoteDataSource(this._apiClient);

  Future<List<DoctorApiModel>> getDoctors({
    String? specialization,
    String? searchQuery,
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, dynamic>{};

    if (specialization != null && specialization.isNotEmpty) {
      queryParams['specialization'] = specialization;
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      queryParams['search'] = searchQuery;
    }
    if (page != null) queryParams['page'] = page;
    if (limit != null) queryParams['limit'] = limit;

    final response = await _apiClient.get(
      ApiEndpoints.doctors,
      queryParameters: queryParams,
    );

    final data = response.data['data'] as List<dynamic>;
    return data
        .map((json) => DoctorApiModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<DoctorApiModel> getDoctorById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.doctorById(id));
    final data = response.data['data'] as Map<String, dynamic>;
    return DoctorApiModel.fromJson(data);
  }

  Future<Map<String, dynamic>> getDoctorAvailability(
    String doctorId,
    String date,
  ) async {
    final response = await _apiClient.get(
      ApiEndpoints.doctorAvailability(doctorId),
      queryParameters: {'date': date},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getDoctorReviews(String doctorId) async {
    final response = await _apiClient.get(ApiEndpoints.doctorReviews(doctorId));
    final data = response.data['data'] as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }

  Future<bool> addDoctorReview(
    String doctorId,
    double rating,
    String? comment,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.doctorReviews(doctorId),
      data: {
        'rating': rating,
        'comment': comment,
      },
    );
    return response.data['success'] == true;
  }

  Future<List<String>> getSpecializations() async {
    final response = await _apiClient.get(ApiEndpoints.specializations);
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((item) {
          if (item is String) {
            return item;
          }
          if (item is Map<String, dynamic>) {
            return item['name'] as String? ?? '';
          }
          return '';
        })
        .where((name) => name.isNotEmpty)
        .toList();
  }
}
