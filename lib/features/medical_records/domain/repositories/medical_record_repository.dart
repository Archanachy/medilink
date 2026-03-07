import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/medical_records/domain/entities/medical_record_entity.dart';

abstract interface class IMedicalRecordRepository {
  Future<Either<Failure, MedicalRecordEntity>> uploadRecord({
    required String patientId,
    String? doctorId,
    required String title,
    required String type,
    required String filePath,
    String? notes,
  });

  Future<Either<Failure, List<MedicalRecordEntity>>> getRecords({
    required String patientId,
    int? page,
    int? limit,
  });
}
