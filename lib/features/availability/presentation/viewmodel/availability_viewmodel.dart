import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/availability/data/providers/availability_providers.dart';
import 'package:medilink/features/availability/domain/entities/availability_entity.dart';
import 'package:medilink/features/availability/presentation/state/availability_state.dart';

class AvailabilityViewmodel extends Notifier<AvailabilityState> {
  @override
  AvailabilityState build() {
    return const AvailabilityState();
  }

  Future<void> loadDoctorSchedule(
    String doctorId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = state.copyWith(
      isLoading: true,
      status: AvailabilityStatus.loading,
    );

    final usecase = ref.read(getDoctorScheduleUsecaseProvider);
    final result = await usecase(doctorId, startDate: startDate, endDate: endDate);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: AvailabilityStatus.error,
          error: failure.message,
        );
      },
      (schedule) {
        state = state.copyWith(
          isLoading: false,
          status: AvailabilityStatus.loaded,
          schedule: schedule,
          error: null,
        );
      },
    );
  }

  Future<void> loadAvailableSlots(String doctorId, DateTime date) async {
    state = state.copyWith(
      isLoading: true,
      selectedDate: date,
    );

    final usecase = ref.read(getAvailableSlotsUsecaseProvider);
    final result = await usecase(doctorId, date);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: AvailabilityStatus.error,
          error: failure.message,
        );
      },
      (slots) {
        state = state.copyWith(
          isLoading: false,
          status: AvailabilityStatus.loaded,
          availableSlots: slots,
          error: null,
        );
      },
    );
  }

  Future<bool> createSlot(AvailabilitySlot slot) async {
    state = state.copyWith(isLoading: true);

    final usecase = ref.read(createAvailabilitySlotUsecaseProvider);
    final result = await usecase(slot);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return false;
      },
      (createdSlot) {
        // Refresh the schedule
        if (state.schedule != null) {
          loadDoctorSchedule(state.schedule!.doctorId);
        }
        state = state.copyWith(isLoading: false, error: null);
        return true;
      },
    );
  }

  Future<bool> updateSlot(AvailabilitySlot slot) async {
    state = state.copyWith(isLoading: true);

    final usecase = ref.read(updateAvailabilitySlotUsecaseProvider);
    final result = await usecase(slot);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return false;
      },
      (updatedSlot) {
        // Refresh the schedule
        if (state.schedule != null) {
          loadDoctorSchedule(state.schedule!.doctorId);
        }
        state = state.copyWith(isLoading: false, error: null);
        return true;
      },
    );
  }

  Future<bool> deleteSlot(String slotId) async {
    state = state.copyWith(isLoading: true);

    final usecase = ref.read(deleteAvailabilitySlotUsecaseProvider);
    final result = await usecase(slotId);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return false;
      },
      (_) {
        // Refresh the schedule
        if (state.schedule != null) {
          loadDoctorSchedule(state.schedule!.doctorId);
        }
        state = state.copyWith(isLoading: false, error: null);
        return true;
      },
    );
  }

  Future<bool> addHoliday(String doctorId, DateTime date, String reason) async {
    state = state.copyWith(isLoading: true);

    final usecase = ref.read(addHolidayUsecaseProvider);
    final result = await usecase(doctorId, date, reason);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return false;
      },
      (_) {
        // Refresh the schedule
        loadDoctorSchedule(doctorId);
        state = state.copyWith(isLoading: false, error: null);
        return true;
      },
    );
  }

  void clearError() {
    state = state.clearError();
  }
}
