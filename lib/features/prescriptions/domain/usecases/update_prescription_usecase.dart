import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:medilink/features/prescriptions/domain/repositories/i_prescription_repository.dart';

class UpdatePrescriptionUsecase {
  final IPrescriptionRepository repository;

  UpdatePrescriptionUsecase(this.repository);

  Future<Either<Failure, bool>> call(PrescriptionEntity prescription) {
    return repository.updatePrescription(prescription);
  }
}
