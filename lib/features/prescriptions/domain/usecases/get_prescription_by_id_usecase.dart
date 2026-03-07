import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:medilink/features/prescriptions/domain/repositories/i_prescription_repository.dart';

class GetPrescriptionByIdUsecase {
  final IPrescriptionRepository repository;

  GetPrescriptionByIdUsecase(this.repository);

  Future<Either<Failure, PrescriptionEntity>> call(String id) {
    return repository.getPrescriptionById(id);
  }
}
