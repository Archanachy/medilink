import 'package:medilink/features/availability/domain/entities/availability_entity.dart';

enum AvailabilityStatus {
  idle,
  loading,
  loaded,
  error,
}

class AvailabilityState {
  final AvailabilityStatus status;
  final DoctorSchedule? schedule;
  final List<AvailabilitySlot> availableSlots;
  final DateTime? selectedDate;
  final bool isLoading;
  final String? error;

  const AvailabilityState({
    this.status = AvailabilityStatus.idle,
    this.schedule,
    this.availableSlots = const [],
    this.selectedDate,
    this.isLoading = false,
    this.error,
  });

  AvailabilityState copyWith({
    AvailabilityStatus? status,
    DoctorSchedule? schedule,
    List<AvailabilitySlot>? availableSlots,
    DateTime? selectedDate,
    bool? isLoading,
    String? error,
  }) {
    return AvailabilityState(
      status: status ?? this.status,
      schedule: schedule ?? this.schedule,
      availableSlots: availableSlots ?? this.availableSlots,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  AvailabilityState clearError() {
    return copyWith(error: null);
  }
}
