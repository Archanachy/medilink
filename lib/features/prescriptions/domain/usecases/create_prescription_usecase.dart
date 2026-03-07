import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:medilink/features/prescriptions/domain/repositories/i_prescription_repository.dart';

class CreatePrescriptionUsecase {
  final IPrescriptionRepository repository;

  CreatePrescriptionUsecase(this.repository);

  Future<Either<Failure, bool>> call(PrescriptionEntity prescription) {
    return repository.createPrescription(prescription);
  }
}
