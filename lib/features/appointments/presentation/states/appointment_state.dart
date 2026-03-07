import 'package:equatable/equatable.dart';
import 'package:medilink/features/appointments/domain/entities/appointment_entity.dart';

enum AppointmentStatus { initial, loading, success, error }

const Object _appointmentStateUnset = Object();

class AppointmentState extends Equatable {
  final AppointmentStatus status;
  final List<AppointmentEntity> appointments;
  final AppointmentEntity? selectedAppointment;
  final String? errorMessage;

  const AppointmentState({
    this.status = AppointmentStatus.initial,
    this.appointments = const [],
    this.selectedAppointment,
    this.errorMessage,
  });

  AppointmentState copyWith({
    AppointmentStatus? status,
    List<AppointmentEntity>? appointments,
    Object? selectedAppointment = _appointmentStateUnset,
    Object? errorMessage = _appointmentStateUnset,
  }) {
    return AppointmentState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      selectedAppointment: selectedAppointment == _appointmentStateUnset
          ? this.selectedAppointment
          : selectedAppointment as AppointmentEntity?,
      errorMessage: errorMessage == _appointmentStateUnset
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, appointments, selectedAppointment, errorMessage];
}
