import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/medical_records/domain/usecases/get_records_usecase.dart';
import 'package:medilink/features/medical_records/domain/usecases/upload_record_usecase.dart';
import 'package:medilink/features/medical_records/presentation/states/medical_record_state.dart';

final medicalRecordViewModelProvider =
    NotifierProvider<MedicalRecordViewModel, MedicalRecordState>(
  MedicalRecordViewModel.new,
);

class MedicalRecordViewModel extends Notifier<MedicalRecordState> {
  late final UploadRecordUsecase _uploadRecordUsecase;
  late final GetRecordsUsecase _getRecordsUsecase;
  late final UserSessionService _userSessionService;

  @override
  MedicalRecordState build() {
    _uploadRecordUsecase = ref.read(uploadRecordUsecaseProvider);
    _getRecordsUsecase = ref.read(getRecordsUsecaseProvider);
    _userSessionService = ref.read(userSessionServiceProvider);
    return const MedicalRecordState();
  }

  String? _resolveCurrentPatientId() {
    final role = _userSessionService.getCurrentUserRole()?.toLowerCase();
    if (role == 'doctor') {
      return null;
    }

    final patientId = _userSessionService.getCurrentPatientId();
    if (patientId != null && patientId.isNotEmpty) {
      return patientId;
    }

    final userId = _userSessionService.getCurrentUserId();
    if (userId != null && userId.isNotEmpty) {
      return userId;
    }

    return null;
  }

  Future<void> fetchCurrentPatientRecords() async {
    final role = _userSessionService.getCurrentUserRole()?.toLowerCase();
    if (role == 'doctor') {
      state = state.copyWith(
        status: MedicalRecordStatus.success,
        records: const [],
        selectedRecord: null,
        errorMessage: null,
      );
      return;
    }

    final patientId = _resolveCurrentPatientId();
    if (patientId == null) {
      state = state.copyWith(
        status: MedicalRecordStatus.error,
        records: const [],
        selectedRecord: null,
        errorMessage: 'Patient session not found. Please login again.',
      );
      return;
    }

    await fetchRecords(patientId: patientId);
  }

  Future<void> fetchRecords({required String patientId}) async {
    state = state.copyWith(status: MedicalRecordStatus.loading);
    final params = GetRecordsParams(patientId: patientId);
    final result = await _getRecordsUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: MedicalRecordStatus.error,
          errorMessage: failure.message,
        );
      },
      (records) {
        state = state.copyWith(
          status: MedicalRecordStatus.success,
          records: records,
          errorMessage: null,
        );
      },
    );
  }

  Future<bool> uploadRecord({
    required String patientId,
    String? doctorId,
    required String title,
    required String type,
    required String filePath,
    String? notes,
  }) async {
    state = state.copyWith(status: MedicalRecordStatus.loading);
    final params = UploadRecordParams(
      patientId: patientId,
      doctorId: doctorId,
      title: title,
      type: type,
      filePath: filePath,
      notes: notes,
    );

    final result = await _uploadRecordUsecase(params);
    return result.fold(
      (failure) {
        state = state.copyWith(
          status: MedicalRecordStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (record) {
        final updated = List.of(state.records)..insert(0, record);
        state = state.copyWith(
          status: MedicalRecordStatus.success,
          records: updated,
          selectedRecord: record,
          errorMessage: null,
        );
        return true;
      },
    );
  }

  Future<bool> uploadCurrentPatientRecord({
    String? doctorId,
    required String title,
    required String type,
    required String filePath,
    String? notes,
  }) async {
    final patientId = _resolveCurrentPatientId();
    if (patientId == null) {
      state = state.copyWith(
        status: MedicalRecordStatus.error,
        errorMessage: 'Patient session not found. Please login again.',
      );
      return false;
    }

    return uploadRecord(
      patientId: patientId,
      doctorId: doctorId,
      title: title,
      type: type,
      filePath: filePath,
      notes: notes,
    );
  }

  void selectRecord(String id) {
    final match = state.records.firstWhere(
      (record) => record.id == id,
      orElse: () => state.selectedRecord ?? state.records.first,
    );
    state = state.copyWith(selectedRecord: match);
  }
}
