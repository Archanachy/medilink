import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/medical_records/data/repositories/medical_record_repository_impl.dart';
import 'package:medilink/features/medical_records/domain/entities/medical_record_entity.dart';
import 'package:medilink/features/medical_records/domain/repositories/medical_record_repository.dart';

class GetRecordsParams extends Equatable {
  final String patientId;
  final int? page;
  final int? limit;

  const GetRecordsParams({
    required this.patientId,
    this.page,
    this.limit,
  });

  @override
  List<Object?> get props => [patientId, page, limit];
}

final getRecordsUsecaseProvider = Provider<GetRecordsUsecase>((ref) {
  return GetRecordsUsecase(ref.read(medicalRecordRepositoryProvider));
});

class GetRecordsUsecase
    implements UsecaseWithParams<List<MedicalRecordEntity>, GetRecordsParams> {
  final IMedicalRecordRepository _repository;

  GetRecordsUsecase(this._repository);

  @override
  Future<Either<Failure, List<MedicalRecordEntity>>> call(GetRecordsParams params) {
    return _repository.getRecords(
      patientId: params.patientId,
      page: params.page,
      limit: params.limit,
    );
  }
}
