import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/appointments/domain/entities/appointment_entity.dart';
import 'package:medilink/features/appointments/domain/usecases/book_appointment_usecase.dart';
import 'package:medilink/features/appointments/domain/usecases/cancel_appointment_usecase.dart';
import 'package:medilink/features/appointments/domain/usecases/get_appointments_usecase.dart';
import 'package:medilink/features/appointments/presentation/states/appointment_state.dart';

final appointmentViewModelProvider = NotifierProvider<AppointmentViewModel, AppointmentState>(
  AppointmentViewModel.new,
);

class AppointmentViewModel extends Notifier<AppointmentState> {
  late final BookAppointmentUsecase _bookAppointmentUsecase;
  late final GetAppointmentsUsecase _getAppointmentsUsecase;
  late final CancelAppointmentUsecase _cancelAppointmentUsecase;

  @override
  AppointmentState build() {
    _bookAppointmentUsecase = ref.read(bookAppointmentUsecaseProvider);
    _getAppointmentsUsecase = ref.read(getAppointmentsUsecaseProvider);
    _cancelAppointmentUsecase = ref.read(cancelAppointmentUsecaseProvider);
    return const AppointmentState();
  }

  Future<void> fetchAppointments({String? userId, String? status}) async {
    state = state.copyWith(status: AppointmentStatus.loading);
    final params = GetAppointmentsParams(userId: userId, status: status);
    final result = await _getAppointmentsUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AppointmentStatus.error,
          errorMessage: failure.message,
        );
      },
      (appointments) {
        state = state.copyWith(
          status: AppointmentStatus.success,
          appointments: appointments,
          errorMessage: null,
        );
      },
    );
  }

  Future<bool> bookAppointment({
    required String doctorId,
    required String patientId,
    required DateTime date,
    required String startTime,
    required String endTime,
    String? reason,
    String? symptoms,
  }) async {
    state = state.copyWith(status: AppointmentStatus.loading);

    final params = BookAppointmentParams(
      doctorId: doctorId,
      patientId: patientId,
      date: date,
      startTime: startTime,
      endTime: endTime,
      reason: reason,
      symptoms: symptoms,
    );

    final result = await _bookAppointmentUsecase(params);
    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AppointmentStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (appointment) {
        state = state.copyWith(
          status: AppointmentStatus.success,
          selectedAppointment: appointment,
          errorMessage: null,
        );
        return true;
      },
    );
  }

  Future<bool> cancelAppointment({required String appointmentId, String? reason}) async {
    state = state.copyWith(status: AppointmentStatus.loading);
    final params = CancelAppointmentParams(
      appointmentId: appointmentId,
      reason: reason,
    );
    final result = await _cancelAppointmentUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AppointmentStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (success) {
        if (success) {
          final updatedAppointments = state.appointments
              .map(
                (appointment) => appointment.id == appointmentId
                    ? AppointmentEntity(
                        id: appointment.id,
                        patientId: appointment.patientId,
                        doctorId: appointment.doctorId,
                        patientName: appointment.patientName,
                        doctorName: appointment.doctorName,
                        doctorSpecialization: appointment.doctorSpecialization,
                        appointmentDate: appointment.appointmentDate,
                        startTime: appointment.startTime,
                        endTime: appointment.endTime,
                        status: 'cancelled',
                        reason: appointment.reason,
                        location: appointment.location,
                        consultationFee: appointment.consultationFee,
                        createdAt: appointment.createdAt,
                      )
                    : appointment,
              )
              .toList();

          final selected = state.selectedAppointment;
          final updatedSelected = selected != null && selected.id == appointmentId
              ? AppointmentEntity(
                  id: selected.id,
                  patientId: selected.patientId,
                  doctorId: selected.doctorId,
                  patientName: selected.patientName,
                  doctorName: selected.doctorName,
                  doctorSpecialization: selected.doctorSpecialization,
                  appointmentDate: selected.appointmentDate,
                  startTime: selected.startTime,
                  endTime: selected.endTime,
                  status: 'cancelled',
                  reason: selected.reason,
                  location: selected.location,
                  consultationFee: selected.consultationFee,
                  createdAt: selected.createdAt,
                )
              : selected;

          state = state.copyWith(
            status: AppointmentStatus.success,
            appointments: updatedAppointments,
            selectedAppointment: updatedSelected,
            errorMessage: null,
          );
        } else {
          state = state.copyWith(status: AppointmentStatus.success);
        }
        return success;
      },
    );
  }

  void selectAppointment(String id) {
    if (state.appointments.isEmpty) {
      state = state.copyWith(selectedAppointment: null);
      return;
    }

    final matches = state.appointments.where(
      (appointment) => appointment.id == id,
    );

    if (matches.isNotEmpty) {
      state = state.copyWith(selectedAppointment: matches.first);
      return;
    }

    state = state.copyWith(selectedAppointment: state.appointments.first);
  }
}
