import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/core/api/api_endpoints.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/prescriptions/data/models/prescription_api_model.dart';

final prescriptionRemoteDatasourceProvider =
    Provider<IPrescriptionRemoteDataSource>((ref) {
  return PrescriptionRemoteDataSource(
    ref.read(apiClientProvider),
    ref.read(userSessionServiceProvider),
  );
});

abstract class IPrescriptionRemoteDataSource {
  Future<List<PrescriptionApiModel>> getPrescriptions(String patientId);
  Future<PrescriptionApiModel> getPrescriptionById(String id);
  Future<bool> createPrescription(PrescriptionApiModel prescription);
  Future<bool> updatePrescription(PrescriptionApiModel prescription);
}

class PrescriptionRemoteDataSource implements IPrescriptionRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _sessionService;

  PrescriptionRemoteDataSource(this._apiClient, this._sessionService);

  bool get _isDoctor =>
      (_sessionService.getCurrentUserRole() ?? '').toLowerCase() == 'doctor';

  @override
  Future<List<PrescriptionApiModel>> getPrescriptions(String patientId) async {
    try {
      final endpoint = _isDoctor
          ? ApiEndpoints.doctorPrescriptions
          : ApiEndpoints.patientPrescriptions;

      final queryParameters = _isDoctor
          ? {
              'doctorId': _sessionService.getCurrentUserId(),
              'page': 1,
              'limit': 50,
            }
          : {
              'patientId': patientId,
              'page': 1,
              'limit': 50,
            };

      final response = await _apiClient.get(
        endpoint,
        queryParameters: queryParameters,
      );

      final data = response.data['data'] as List<dynamic>;
      return data
          .map((json) =>
              PrescriptionApiModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PrescriptionApiModel> getPrescriptionById(String id) async {
    try {
      final endpoint = _isDoctor
          ? '${ApiEndpoints.doctorPrescriptions}/$id'
          : '${ApiEndpoints.patientPrescriptions}/$id';

      final response = await _apiClient.get(endpoint);

      final data = response.data['data'] as Map<String, dynamic>;
      return PrescriptionApiModel.fromBackendDetailJson(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> createPrescription(PrescriptionApiModel prescription) async {
    try {
      final composedNotes = _composeNotes(
        diagnosis: prescription.diagnosis,
        notes: prescription.notes,
      );

      final requestData = {
        'patientId': prescription.patientId,
        'doctorId': prescription.doctorId,
        'appointmentId': prescription.appointmentId,
        'notes': composedNotes,
        'status': prescription.status,
        'items': prescription.medications
            .map(
              (m) => {
                'name': m.name,
                'dosage': m.dosage,
                'frequency': m.frequency,
                'duration': m.duration,
                'instructions': m.instructions ?? '',
              },
            )
            .toList(),
      };

      final response = await _apiClient.post(
        ApiEndpoints.doctorPrescriptions,
        data: requestData,
      );

      return response.statusCode == 201;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updatePrescription(PrescriptionApiModel prescription) async {
    try {
      final composedNotes = _composeNotes(
        diagnosis: prescription.diagnosis,
        notes: prescription.notes,
      );

      final response = await _apiClient.put(
        '${ApiEndpoints.doctorPrescriptions}/${prescription.id}',
        data: {
          'patientId': prescription.patientId,
          'doctorId': prescription.doctorId,
          'appointmentId': prescription.appointmentId,
          'notes': composedNotes,
          'status': prescription.status,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  String _composeNotes({String? diagnosis, String? notes}) {
    final diagnosisText = diagnosis?.trim();
    final notesText = notes?.trim();

    if ((diagnosisText == null || diagnosisText.isEmpty) &&
        (notesText == null || notesText.isEmpty)) {
      return '';
    }

    if (diagnosisText == null || diagnosisText.isEmpty) {
      return notesText!;
    }

    if (notesText == null || notesText.isEmpty) {
      return 'Diagnosis: $diagnosisText';
    }

    return 'Diagnosis: $diagnosisText\n$notesText';
  }
}
