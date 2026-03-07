import 'package:medilink/features/prescriptions/domain/entities/prescription_entity.dart';

class PrescriptionApiModel {
  final String id;
  final String patientId;
  final String doctorId;
  final String doctorName;
  final String? appointmentId;
  final List<MedicationApiModel> medications;
  final String? diagnosis;
  final String? notes;
  final String date;
  final String status;

  PrescriptionApiModel({
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

  factory PrescriptionApiModel.fromJson(Map<String, dynamic> json) {
    final medicationsSource =
        (json['medications'] ?? json['items']) as List<dynamic>?;

    final rawDate =
        (json['date'] ?? json['created_at'] ?? json['createdAt'])?.toString();

    final doctorId = (json['doctor_id'] ?? json['doctorId'] ?? '').toString();
    final doctorNameRaw =
        (json['doctor_name'] ?? json['doctorName'] ?? '').toString();
    final doctorName = doctorNameRaw.isNotEmpty ? doctorNameRaw : 'Doctor';

    final notesValue = json['notes']?.toString();
    final diagnosisValue = json['diagnosis']?.toString();

    String? parsedDiagnosis = diagnosisValue;
    if ((parsedDiagnosis == null || parsedDiagnosis.isEmpty) &&
        notesValue != null &&
        notesValue.startsWith('Diagnosis: ')) {
      final lines = notesValue.split('\n');
      if (lines.isNotEmpty) {
        parsedDiagnosis = lines.first.replaceFirst('Diagnosis: ', '').trim();
      }
    }

    return PrescriptionApiModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      patientId: (json['patient_id'] ?? json['patientId'] ?? '').toString(),
      doctorId: doctorId,
      doctorName: doctorName,
      appointmentId:
          (json['appointment_id'] ?? json['appointmentId'])?.toString(),
      medications: medicationsSource
              ?.map((e) => MedicationApiModel.fromJson(e))
              .toList() ??
          [],
      diagnosis: (parsedDiagnosis != null && parsedDiagnosis.isNotEmpty)
          ? parsedDiagnosis
          : null,
      notes: notesValue,
      date: rawDate?.isNotEmpty == true
          ? rawDate!
          : DateTime.now().toIso8601String(),
      status: (json['status'] ?? 'active').toString(),
    );
  }

  factory PrescriptionApiModel.fromBackendDetailJson(
      Map<String, dynamic> json) {
    final prescription =
        (json['prescription'] as Map<String, dynamic>?) ?? json;
    final items = (json['items'] as List<dynamic>?) ?? const <dynamic>[];

    return PrescriptionApiModel.fromJson({
      ...prescription,
      'items': items,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'appointment_id': appointmentId,
      'medications': medications.map((e) => e.toJson()).toList(),
      'diagnosis': diagnosis,
      'notes': notes,
      'date': date,
      'status': status,
    };
  }

  PrescriptionEntity toEntity() {
    return PrescriptionEntity(
      id: id,
      patientId: patientId,
      doctorId: doctorId,
      doctorName: doctorName,
      appointmentId: appointmentId,
      medications: medications.map((e) => e.toEntity()).toList(),
      diagnosis: diagnosis,
      notes: notes,
      date: DateTime.parse(date),
      status: status,
    );
  }

  factory PrescriptionApiModel.fromEntity(PrescriptionEntity entity) {
    return PrescriptionApiModel(
      id: entity.id,
      patientId: entity.patientId,
      doctorId: entity.doctorId,
      doctorName: entity.doctorName,
      appointmentId: entity.appointmentId,
      medications: entity.medications
          .map((e) => MedicationApiModel.fromEntity(e))
          .toList(),
      diagnosis: entity.diagnosis,
      notes: entity.notes,
      date: entity.date.toIso8601String(),
      status: entity.status,
    );
  }
}

class MedicationApiModel {
  final String name;
  final String dosage;
  final String frequency;
  final String duration;
  final String? instructions;

  MedicationApiModel({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    this.instructions,
  });

  factory MedicationApiModel.fromJson(Map<String, dynamic> json) {
    return MedicationApiModel(
      name: json['name'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      duration: json['duration'] ?? '',
      instructions: json['instructions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'instructions': instructions,
    };
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

  factory MedicationApiModel.fromEntity(Medication entity) {
    return MedicationApiModel(
      name: entity.name,
      dosage: entity.dosage,
      frequency: entity.frequency,
      duration: entity.duration,
      instructions: entity.instructions,
    );
  }
}
