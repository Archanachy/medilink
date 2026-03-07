import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/prescriptions/domain/entities/prescription_entity.dart';

abstract class IPrescriptionRepository {
  Future<Either<Failure, List<PrescriptionEntity>>> getPrescriptions(
    String patientId,
  );

  Future<Either<Failure, PrescriptionEntity>> getPrescriptionById(String id);

  Future<Either<Failure, bool>> createPrescription(
    PrescriptionEntity prescription,
  );

  Future<Either<Failure, bool>> updatePrescription(
    PrescriptionEntity prescription,
  );
}
