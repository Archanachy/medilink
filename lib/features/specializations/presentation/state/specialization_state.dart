import 'package:medilink/features/specializations/domain/entities/specialization_entity.dart';

enum SpecializationStatus {
  idle,
  loading,
  loaded,
  error,
}

class SpecializationState {
  final SpecializationStatus status;
  final List<SpecializationEntity> specializations;
  final SpecializationEntity? selectedSpecialization;
  final bool isLoading;
  final String? error;

  const SpecializationState({
    this.status = SpecializationStatus.idle,
    this.specializations = const [],
    this.selectedSpecialization,
    this.isLoading = false,
    this.error,
  });

  SpecializationState copyWith({
    SpecializationStatus? status,
    List<SpecializationEntity>? specializations,
    SpecializationEntity? selectedSpecialization,
    bool? isLoading,
    String? error,
  }) {
    return SpecializationState(
      status: status ?? this.status,
      specializations: specializations ?? this.specializations,
      selectedSpecialization:
          selectedSpecialization ?? this.selectedSpecialization,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  SpecializationState clearError() {
    return copyWith(error: null);
  }
}
