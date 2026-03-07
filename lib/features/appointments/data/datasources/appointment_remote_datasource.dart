import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/core/api/api_endpoints.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/appointments/data/models/appointment_api_model.dart';

final appointmentRemoteDatasourceProvider = Provider<AppointmentRemoteDatasource>((ref) {
  return AppointmentRemoteDatasource(
    ref.read(apiClientProvider),
    ref.read(userSessionServiceProvider),
  );
});

class AppointmentRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final _secureStorage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  AppointmentRemoteDatasource(this._apiClient, this._userSessionService);

  /// Extract role from JWT token
  Future<String?> _getRoleFromJWT() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);
      if (token == null || token.isEmpty) {
        if (kDebugMode) {
          print('[JWT_EXTRACT] No token found in secure storage');
        }
        return null;
      }

      // JWT format: header.payload.signature
      final parts = token.split('.');
      if (parts.length != 3) {
        if (kDebugMode) {
          print('[JWT_EXTRACT] Invalid JWT format');
        }
        return null;
      }

      // Decode the payload (add padding if necessary)
      String payload = parts[1];
      // Add padding if necessary
      final paddingNeeded = (4 - (payload.length % 4)) % 4;
      if (paddingNeeded > 0) {
        payload += '=' * paddingNeeded;
      }

      final decodedBytes = base64Url.decode(payload);
      final decodedPayload = json.decode(utf8.decode(decodedBytes)) as Map<String, dynamic>;
      
      final role = decodedPayload['role'] as String?;
      if (kDebugMode) {
        print('[JWT_EXTRACT] Extracted role from JWT: "$role"');
      }
      return role;
    } catch (e) {
      if (kDebugMode) {
        print('[JWT_EXTRACT] Error extracting role from JWT: $e');
      }
      return null;
    }
  }


  Future<AppointmentApiModel> bookAppointment({
    required String doctorId,
    required String patientId,
    required DateTime date,
    required String startTime,
    required String endTime,
    String? reason,
    String? symptoms,
  }) async {
    // Combine date with startTime to create proper DateTime
    final timeParts = startTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    
    final appointmentDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
    
    // Calculate duration from startTime to endTime
    final endTimeParts = endTime.split(':');
    final endHour = int.parse(endTimeParts[0]);
    final endMinute = int.parse(endTimeParts[1]);
    final startMinutes = hour * 60 + minute;
    final endMinutes = endHour * 60 + endMinute;
    final duration = endMinutes - startMinutes;
    
    final response = await _apiClient.post(
      ApiEndpoints.appointments,
      data: {
        'doctorId': doctorId,
        'patientId': patientId,
        'appointmentDate': appointmentDateTime.toUtc().toIso8601String(),
        'duration': duration,
        'reason': reason,
        'symptoms': symptoms,
      },
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return AppointmentApiModel.fromJson(data);
  }

  Future<List<AppointmentApiModel>> getAppointments({
    String? userId,
    String? status,
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;
    if (page != null) queryParams['page'] = page;
    if (limit != null) queryParams['limit'] = limit;

    // Use role-specific endpoint based on JWT role
    String endpoint;
    if (userId != null && userId.isNotEmpty) {
      // Extract role from JWT token (most reliable source)
      final jwtRole = await _getRoleFromJWT();
      final role = (jwtRole ?? _userSessionService.getCurrentUserRole() ?? '').toLowerCase();
      
      if (kDebugMode) {
        print('[APPOINTMENTS] Using role for endpoint selection: "$role"');
      }
      
      if (role == 'doctor') {
        endpoint = ApiEndpoints.appointmentsByDoctor(userId);
      } else {
        // Default to patient endpoint
        endpoint = ApiEndpoints.appointmentsByUser(userId);
      }
      
      if (kDebugMode) {
        print('[APPOINTMENTS] Calling endpoint: $endpoint');
      }
    } else {
      endpoint = ApiEndpoints.appointments;
    }

    final response = await _apiClient.get(
      endpoint,
      queryParameters: queryParams,
    );

    final data = response.data['data'] as List<dynamic>;
    return data
        .map((json) {
          try {
            return AppointmentApiModel.fromJson(json as Map<String, dynamic>);
          } catch (e) {
            if (kDebugMode) {
              print('[APPOINTMENT_PARSE_ERROR] Failed to parse appointment: $e');
              print('[APPOINTMENT_JSON] $json');
            }
            return null;
          }
        })
        .whereType<AppointmentApiModel>() // Filter out null values
        .toList();
  }

  Future<bool> cancelAppointment(String appointmentId, {String? reason}) async {
    final response = await _apiClient.patch(
      ApiEndpoints.cancelAppointment(appointmentId),
      data: {'reason': reason},
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      final success = responseData['success'];
      if (success is bool) {
        return success;
      }

      final status = responseData['status']?.toString().toLowerCase();
      if (status == 'cancelled' || status == 'canceled') {
        return true;
      }

      final nestedData = responseData['data'];
      if (nestedData is Map<String, dynamic>) {
        final nestedStatus = nestedData['status']?.toString().toLowerCase();
        if (nestedStatus == 'cancelled' || nestedStatus == 'canceled') {
          return true;
        }
      }
    }

    final statusCode = response.statusCode ?? 0;
    return statusCode >= 200 && statusCode < 300;
  }
}
