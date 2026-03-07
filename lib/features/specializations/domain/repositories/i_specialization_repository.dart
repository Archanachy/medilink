import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/specializations/domain/entities/specialization_entity.dart';

abstract class ISpecializationRepository {
  Future<Either<Failure, List<SpecializationEntity>>> getSpecializations();
  Future<Either<Failure, SpecializationEntity>> getSpecializationById(String id);
}
