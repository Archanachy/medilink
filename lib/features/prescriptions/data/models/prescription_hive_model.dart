import 'package:hive/hive.dart';
import 'package:medilink/features/prescriptions/domain/entities/prescription_entity.dart';

part 'prescription_hive_model.g.dart';

@HiveType(typeId: 10)
class PrescriptionHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String patientId;

  @HiveField(2)
  final String doctorId;

  @HiveField(3)
  final String doctorName;

  @HiveField(4)
  final List<MedicationHiveModel> medications;

  @HiveField(5)
  final String? diagnosis;

  @HiveField(6)
  final String? notes;

  @HiveField(7)
  final DateTime date;

  @HiveField(8)
  final String status;

  PrescriptionHiveModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.doctorName,
    required this.medications,
    this.diagnosis,
    this.notes,
    required this.date,
    required this.status,
  });

  factory PrescriptionHiveModel.fromEntity(PrescriptionEntity entity) {
    return PrescriptionHiveModel(
      id: entity.id,
      patientId: entity.patientId,
      doctorId: entity.doctorId,
      doctorName: entity.doctorName,
      medications: entity.medications
          .map((e) => MedicationHiveModel.fromEntity(e))
          .toList(),
      diagnosis: entity.diagnosis,
      notes: entity.notes,
      date: entity.date,
      status: entity.status,
    );
  }

  PrescriptionEntity toEntity() {
    return PrescriptionEntity(
      id: id,
      patientId: patientId,
      doctorId: doctorId,
      doctorName: doctorName,
      medications: medications.map((e) => e.toEntity()).toList(),
      diagnosis: diagnosis,
      notes: notes,
      date: date,
      status: status,
    );
  }
}

@HiveType(typeId: 11)
class MedicationHiveModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String dosage;

  @HiveField(2)
  final String frequency;

  @HiveField(3)
  final String duration;

  @HiveField(4)
  final String? instructions;

  MedicationHiveModel({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    this.instructions,
  });

  factory MedicationHiveModel.fromEntity(Medication entity) {
    return MedicationHiveModel(
      name: entity.name,
      dosage: entity.dosage,
      frequency: entity.frequency,
      duration: entity.duration,
      instructions: entity.instructions,
    );
  }

  Medication toEntity() {
    return Medication(
      name: name,
      dosage: dosage,
      frequency: frequency,
      duration: duration,
      instructions: instructions,
    );
  }
}
