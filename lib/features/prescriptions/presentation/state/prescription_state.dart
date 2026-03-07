import 'package:equatable/equatable.dart';
import 'package:medilink/features/prescriptions/domain/entities/prescription_entity.dart';

class PrescriptionState extends Equatable {
  final bool isLoading;
  final List<PrescriptionEntity> prescriptions;
  final PrescriptionEntity? selectedPrescription;
  final String? error;

  // Create/Update states
  final bool isCreating;
  final bool isUpdating;
  final String? createError;
  final String? updateError;

  // Sync states
  final DateTime? lastSyncTime;
  final bool isSyncing;

  // Filters
  final String filterStatus; // 'all', 'active', 'completed', 'expired'

  const PrescriptionState({
    this.isLoading = false,
    this.prescriptions = const [],
    this.selectedPrescription,
    this.error,
    this.isCreating = false,
    this.isUpdating = false,
    this.createError,
    this.updateError,
    this.lastSyncTime,
    this.isSyncing = false,
    this.filterStatus = 'all',
  });

  PrescriptionState copyWith({
    bool? isLoading,
    List<PrescriptionEntity>? prescriptions,
    PrescriptionEntity? selectedPrescription,
    String? error,
    bool? isCreating,
    bool? isUpdating,
    String? createError,
    String? updateError,
    DateTime? lastSyncTime,
    bool? isSyncing,
    String? filterStatus,
  }) {
    return PrescriptionState(
      isLoading: isLoading ?? this.isLoading,
      prescriptions: prescriptions ?? this.prescriptions,
      selectedPrescription: selectedPrescription ?? this.selectedPrescription,
      error: error ?? this.error,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      createError: createError ?? this.createError,
      updateError: updateError ?? this.updateError,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      isSyncing: isSyncing ?? this.isSyncing,
      filterStatus: filterStatus ?? this.filterStatus,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        prescriptions,
        selectedPrescription,
        error,
        isCreating,
        isUpdating,
        createError,
        updateError,
        lastSyncTime,
        isSyncing,
        filterStatus,
      ];
}
