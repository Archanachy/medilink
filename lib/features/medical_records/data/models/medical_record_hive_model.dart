import 'package:hive/hive.dart';
import 'package:medilink/core/constants/hive_table_constant.dart';
import 'package:medilink/features/medical_records/domain/entities/medical_record_entity.dart';

part 'medical_record_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.medicalRecordTypeId)
class MedicalRecordHiveModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String patientId;
  @HiveField(2)
  final String? doctorId;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final String type;
  @HiveField(5)
  final String fileUrl;
  @HiveField(6)
  final String? notes;
  @HiveField(7)
  final DateTime createdAt;

  MedicalRecordHiveModel({
    required this.id,
    required this.patientId,
    this.doctorId,
    required this.title,
    required this.type,
    required this.fileUrl,
    this.notes,
    required this.createdAt,
  });

  factory MedicalRecordHiveModel.fromEntity(MedicalRecordEntity entity) {
    return MedicalRecordHiveModel(
      id: entity.id,
      patientId: entity.patientId,
      doctorId: entity.doctorId,
      title: entity.title,
      type: entity.type,
      fileUrl: entity.fileUrl,
      notes: entity.notes,
      createdAt: entity.createdAt,
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
}
