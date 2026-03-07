import 'package:medilink/features/medical_records/domain/entities/medical_record_entity.dart';

class MedicalRecordApiModel {
  final String id;
  final String patientId;
  final String? doctorId;
  final String title;
  final String type;
  final String fileUrl;
  final String? notes;
  final DateTime createdAt;

  MedicalRecordApiModel({
    required this.id,
    required this.patientId,
    this.doctorId,
    required this.title,
    required this.type,
    required this.fileUrl,
    this.notes,
    required this.createdAt,
  });

  factory MedicalRecordApiModel.fromJson(Map<String, dynamic> json) {
    final dynamic patientValue = json['patientId'];
    final String resolvedPatientId = patientValue is Map<String, dynamic>
        ? (patientValue['_id'] as String? ??
            patientValue['id'] as String? ??
            '')
        : (patientValue as String? ?? '');

    return MedicalRecordApiModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      patientId: resolvedPatientId,
      doctorId: json['doctorId'] as String?,
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ??
          json['mime_type'] as String? ??
          json['mimeType'] as String? ??
          'file',
      fileUrl: json['fileUrl'] as String? ?? '',
      notes: json['notes'] as String? ?? json['description'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : DateTime.now(),
    );
  }

  MedicalRecordEntity toEntity() {
    return MedicalRecordEntity(
      id: id,
      patientId: patientId,
      doctorId: doctorId,
      title: title,
      type: type,
      fileUrl: fileUrl,
      notes: notes,
      createdAt: createdAt,
    );
  }

  static List<MedicalRecordEntity> toEntityList(
      List<MedicalRecordApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
