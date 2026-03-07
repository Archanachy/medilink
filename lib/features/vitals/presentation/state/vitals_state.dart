import 'package:medilink/features/vitals/domain/entities/vitals_entity.dart';

enum VitalsStatus {
  idle,
  loading,
  loaded,
  recording,
  recorded,
  error,
}

class VitalsState {
  final VitalsStatus status;
  final List<VitalsEntity> vitals;
  final String? selectedVitalType;
  final bool isLoading;
  final String? error;

  const VitalsState({
    this.status = VitalsStatus.idle,
    this.vitals = const [],
    this.selectedVitalType,
    this.isLoading = false,
    this.error,
  });

  VitalsState copyWith({
    VitalsStatus? status,
    List<VitalsEntity>? vitals,
    String? selectedVitalType,
    bool? isLoading,
    String? error,
  }) {
    return VitalsState(
      status: status ?? this.status,
      vitals: vitals ?? this.vitals,
      selectedVitalType: selectedVitalType ?? this.selectedVitalType,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  VitalsState clearError() {
    return copyWith(error: null);
  }

  List<VitalsEntity> getVitalsByType(String type) {
    return vitals.where((v) => v.vitalType == type).toList();
  }
}
