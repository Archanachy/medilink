import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/vitals/data/providers/vitals_providers.dart';
import 'package:medilink/features/vitals/domain/entities/vitals_entity.dart';
import 'package:medilink/features/vitals/presentation/state/vitals_state.dart';

class VitalsViewmodel extends Notifier<VitalsState> {
  @override
  VitalsState build() {
    // Auto-load vitals on initialization
    Future.microtask(() => loadVitals());
    return const VitalsState();
  }

  Future<void> loadVitals({String? vitalType}) async {
    state = state.copyWith(
      isLoading: true,
      status: VitalsStatus.loading,
      selectedVitalType: vitalType,
    );

    final usecase = ref.read(getVitalsUsecaseProvider);
    final result = await usecase(vitalType: vitalType);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: VitalsStatus.error,
          error: failure.message,
        );
      },
      (vitals) {
        state = state.copyWith(
          isLoading: false,
          status: VitalsStatus.loaded,
          vitals: vitals,
          error: null,
        );
      },
    );
  }

  Future<bool> recordVital(VitalsEntity vital) async {
    state = state.copyWith(
      isLoading: true,
      status: VitalsStatus.recording,
    );

    final usecase = ref.read(recordVitalUsecaseProvider);
    final result = await usecase(vital);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: VitalsStatus.error,
          error: failure.message,
        );
        return false;
      },
      (recordedVital) {
        // Refresh vitals
        loadVitals(vitalType: state.selectedVitalType);
        state = state.copyWith(
          isLoading: false,
          status: VitalsStatus.recorded,
          error: null,
        );
        return true;
      },
    );
  }

  Future<bool> deleteVital(String id) async {
    state = state.copyWith(isLoading: true);

    final usecase = ref.read(deleteVitalUsecaseProvider);
    final result = await usecase(id);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return false;
      },
      (_) {
        // Refresh vitals
        loadVitals(vitalType: state.selectedVitalType);
        return true;
      },
    );
  }

  Future<void> loadVitalsByDateRange(
    DateTime startDate,
    DateTime endDate, {
    String? vitalType,
  }) async {
    state = state.copyWith(
      isLoading: true,
      status: VitalsStatus.loading,
    );

    final usecase = ref.read(getVitalsByDateRangeUsecaseProvider);
    final result = await usecase(startDate, endDate, vitalType: vitalType);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: VitalsStatus.error,
          error: failure.message,
        );
      },
      (vitals) {
        state = state.copyWith(
          isLoading: false,
          status: VitalsStatus.loaded,
          vitals: vitals,
          error: null,
        );
      },
    );
  }

  void setVitalType(String? type) {
    loadVitals(vitalType: type);
  }

  void clearError() {
    state = state.clearError();
  }
}
