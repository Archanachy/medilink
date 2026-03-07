import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/features/availability/data/models/availability_api_model.dart';

class AvailabilityRemoteDataSource {
  final ApiClient _apiClient;

  AvailabilityRemoteDataSource(this._apiClient);

  Future<DoctorScheduleApiModel> getDoctorSchedule(
    String doctorId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, dynamic>{
      if (startDate != null)
        'startDate': startDate.toIso8601String().split('T')[0],
      if (endDate != null) 'endDate': endDate.toIso8601String().split('T')[0],
    };

    final response = await _apiClient.get(
      '/doctors/$doctorId/schedule',
      queryParameters: queryParams,
    );

    return DoctorScheduleApiModel.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  Future<List<AvailabilitySlotApiModel>> getAvailableSlots(
      String doctorId, DateTime date) async {
    final response = await _apiClient.get(
      '/doctors/$doctorId/availability',
      queryParameters: {
        'date': date.toIso8601String().split('T')[0],
      },
    );

    final slots = (response.data['data'] as List<dynamic>)
        .map((e) => AvailabilitySlotApiModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return slots;
  }

  Future<AvailabilitySlotApiModel> createAvailabilitySlot(
      AvailabilitySlotApiModel slot) async {
    final response = await _apiClient.post(
      '/availability',
      data: slot.toJson(),
    );

    return AvailabilitySlotApiModel.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  Future<AvailabilitySlotApiModel> updateAvailabilitySlot(
      AvailabilitySlotApiModel slot) async {
    final response = await _apiClient.put(
      '/availability/${slot.id}',
      data: slot.toJson(),
    );

    return AvailabilitySlotApiModel.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  Future<void> deleteAvailabilitySlot(String slotId) async {
    await _apiClient.delete('/availability/$slotId');
  }

  Future<void> addHoliday(String doctorId, DateTime date, String reason) async {
    await _apiClient.post(
      '/doctors/$doctorId/holidays',
      data: {
        'date': date.toIso8601String().split('T')[0],
        'reason': reason,
      },
    );
  }

  Future<void> removeHoliday(String doctorId, DateTime date) async {
    await _apiClient.delete(
      '/doctors/$doctorId/holidays/${date.toIso8601String().split('T')[0]}',
    );
  }
}
