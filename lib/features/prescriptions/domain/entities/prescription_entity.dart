import 'package:equatable/equatable.dart';

class PrescriptionEntity extends Equatable {
  final String id;
  final String patientId;
  final String doctorId;
  final String doctorName;
  final String? appointmentId;
  final List<Medication> medications;
  final String? diagnosis;
  final String? notes;
  final DateTime date;
  final String status; // active, completed, expired

  const PrescriptionEntity({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.doctorName,
    this.appointmentId,
    required this.medications,
    this.diagnosis,
    this.notes,
    required this.date,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        patientId,
        doctorId,
        doctorName,
        appointmentId,
        medications,
        diagnosis,
        notes,
        date,
        status,
      ];
}

class Medication extends Equatable {
  final String name;
  final String dosage;
  final String frequency;
  final String duration;
  final String? instructions;

  const Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    this.instructions,
  });

  @override
  List<Object?> get props => [
        name,
        dosage,
        frequency,
        duration,
        instructions,
      ];
}
