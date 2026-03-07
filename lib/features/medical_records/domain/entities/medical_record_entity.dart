import 'package:equatable/equatable.dart';

class MedicalRecordEntity extends Equatable {
  final String id;
  final String patientId;
  final String? doctorId;
  final String title;
  final String type;
  final String fileUrl;
  final String? notes;
  final DateTime createdAt;

  const MedicalRecordEntity({
    required this.id,
    required this.patientId,
    this.doctorId,
    required this.title,
    required this.type,
    required this.fileUrl,
    this.notes,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    patientId,
    doctorId,
    title,
    type,
    fileUrl,
    notes,
    createdAt,
  ];
}
