import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/specializations/data/providers/specialization_providers.dart';
import 'package:medilink/features/specializations/presentation/state/specialization_state.dart';

class SpecializationViewmodel extends Notifier<SpecializationState> {
  @override
  SpecializationState build() {
    // Auto-load specializations on initialization
    Future.microtask(() => loadSpecializations());
    return const SpecializationState();
  }

  Future<void> loadSpecializations() async {
    if (state.status == SpecializationStatus.loading) return;

    state = state.copyWith(
      isLoading: true,
      status: SpecializationStatus.loading,
    );

    final usecase = ref.read(getSpecializationsUsecaseProvider);
    final result = await usecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: SpecializationStatus.error,
          error: failure.message,
        );
      },
      (specializations) {
        state = state.copyWith(
          isLoading: false,
          status: SpecializationStatus.loaded,
          specializations: specializations,
          error: null,
        );
      },
    );
  }

  Future<void> loadSpecializationById(String id) async {
    state = state.copyWith(isLoading: true);

    final usecase = ref.read(getSpecializationByIdUsecaseProvider);
    final result = await usecase(id);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (specialization) {
        state = state.copyWith(
          isLoading: false,
          selectedSpecialization: specialization,
          error: null,
        );
      },
    );
  }

  void clearError() {
    state = state.clearError();
  }
}
