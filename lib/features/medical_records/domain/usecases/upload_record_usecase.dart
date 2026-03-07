import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/medical_records/data/repositories/medical_record_repository_impl.dart';
import 'package:medilink/features/medical_records/domain/entities/medical_record_entity.dart';
import 'package:medilink/features/medical_records/domain/repositories/medical_record_repository.dart';

class UploadRecordParams extends Equatable {
  final String patientId;
  final String? doctorId;
  final String title;
  final String type;
  final String filePath;
  final String? notes;

  const UploadRecordParams({
    required this.patientId,
    this.doctorId,
    required this.title,
    required this.type,
    required this.filePath,
    this.notes,
  });

  @override
  List<Object?> get props => [patientId, doctorId, title, type, filePath, notes];
}

final uploadRecordUsecaseProvider = Provider<UploadRecordUsecase>((ref) {
  return UploadRecordUsecase(ref.read(medicalRecordRepositoryProvider));
});

class UploadRecordUsecase
    implements UsecaseWithParams<MedicalRecordEntity, UploadRecordParams> {
  final IMedicalRecordRepository _repository;

  UploadRecordUsecase(this._repository);

  @override
  Future<Either<Failure, MedicalRecordEntity>> call(UploadRecordParams params) {
    return _repository.uploadRecord(
      patientId: params.patientId,
      doctorId: params.doctorId,
      title: params.title,
      type: params.type,
      filePath: params.filePath,
      notes: params.notes,
    );
  }
}
