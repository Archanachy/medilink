import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:medilink/features/prescriptions/presentation/providers/prescription_providers.dart';
import 'package:medilink/features/prescriptions/presentation/state/prescription_state.dart';

final prescriptionViewModelProvider =
    NotifierProvider<PrescriptionViewModel, PrescriptionState>(
        () => PrescriptionViewModel());

class PrescriptionViewModel extends Notifier<PrescriptionState> {
  @override
  PrescriptionState build() {
    return const PrescriptionState();
  }

  Future<void> loadPrescriptions(String patientId) async {
    state = state.copyWith(isLoading: true, error: null);

    final usecase = ref.read(getPrescriptionsUsecaseProvider);
    final result = await usecase(patientId);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (prescriptions) {
        state = state.copyWith(
          isLoading: false,
          prescriptions: prescriptions,
          error: null,
        );
      },
    );
  }

  Future<void> loadPrescriptionById(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    final usecase = ref.read(getPrescriptionByIdUsecaseProvider);
    final result = await usecase(id);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (prescription) {
        state = state.copyWith(
          isLoading: false,
          selectedPrescription: prescription,
          error: null,
        );
      },
    );
  }

  Future<bool> createPrescription(PrescriptionEntity prescription) async {
    state = state.copyWith(isCreating: true, createError: null);

    final usecase = ref.read(createPrescriptionUsecaseProvider);
    final result = await usecase(prescription);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isCreating: false,
          createError: failure.message,
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          isCreating: false,
          createError: null,
          error: null,
        );
        return success;
      },
    );
  }

  Future<bool> updatePrescription(PrescriptionEntity prescription) async {
    state = state.copyWith(isUpdating: true, updateError: null);

    final usecase = ref.read(updatePrescriptionUsecaseProvider);
    final result = await usecase(prescription);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isUpdating: false,
          updateError: failure.message,
        );
        return false;
      },
      (success) {
        // Reload the updated prescription
        if (prescription.id.isNotEmpty) {
          loadPrescriptionById(prescription.id);
        }
        state = state.copyWith(isUpdating: false, updateError: null);
        return success;
      },
    );
  }

  void setFilterStatus(String status) {
    state = state.copyWith(filterStatus: status);
  }

  List<PrescriptionEntity> get activePrescriptions {
    return state.prescriptions.where((p) => p.status == 'active').toList();
  }

  List<PrescriptionEntity> get filteredPrescriptions {
    switch (state.filterStatus) {
      case 'active':
        return activePrescriptions;
      case 'completed':
        return completedPrescriptions;
      case 'expired':
        return expiredPrescriptions;
      default:
        return state.prescriptions;
    }
  }

  List<PrescriptionEntity> get completedPrescriptions {
    return state.prescriptions.where((p) => p.status == 'completed').toList();
  }

  List<PrescriptionEntity> get expiredPrescriptions {
    return state.prescriptions.where((p) => p.status == 'expired').toList();
  }
}
