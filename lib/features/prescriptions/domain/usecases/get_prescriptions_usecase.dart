import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:medilink/features/prescriptions/domain/repositories/i_prescription_repository.dart';

class GetPrescriptionsUsecase {
  final IPrescriptionRepository repository;

  GetPrescriptionsUsecase(this.repository);

  Future<Either<Failure, List<PrescriptionEntity>>> call(String patientId) {
    return repository.getPrescriptions(patientId);
  }
}
