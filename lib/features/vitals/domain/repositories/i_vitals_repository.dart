import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/vitals/domain/entities/vitals_entity.dart';

abstract class IVitalsRepository {
  Future<Either<Failure, List<VitalsEntity>>> getVitals({String? vitalType});
  Future<Either<Failure, VitalsEntity>> getVitalById(String id);
  Future<Either<Failure, VitalsEntity>> recordVital(VitalsEntity vital);
  Future<Either<Failure, void>> deleteVital(String id);
  Future<Either<Failure, List<VitalsEntity>>> getVitalsByDateRange(
      DateTime startDate, DateTime endDate, {String? vitalType});
}
