import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/specializations/domain/entities/specialization_entity.dart';
import 'package:medilink/features/specializations/domain/repositories/i_specialization_repository.dart';

class GetSpecializationsUsecase {
  final ISpecializationRepository _repository;

  GetSpecializationsUsecase(this._repository);

  Future<Either<Failure, List<SpecializationEntity>>> call() async {
    return await _repository.getSpecializations();
  }
}
