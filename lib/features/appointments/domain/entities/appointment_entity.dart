import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final String id;
  final String patientId;
  final String doctorId;
  final String patientName;
  final String doctorName;
  final String? doctorSpecialization;
  final DateTime appointmentDate;
  final String startTime;
  final String endTime;
  final String status;
  final String? reason;
  final String? location;
  final double consultationFee;
  final DateTime? createdAt;

  const AppointmentEntity({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.patientName,
    required this.doctorName,
    this.doctorSpecialization,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.reason,
    this.location,
    required this.consultationFee,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    patientId,
    doctorId,
    patientName,
    doctorName,
    doctorSpecialization,
    appointmentDate,
    startTime,
    endTime,
    status,
    reason,
    location,
    consultationFee,
    createdAt,
  ];
}
