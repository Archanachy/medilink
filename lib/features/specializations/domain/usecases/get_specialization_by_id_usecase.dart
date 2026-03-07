import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/specializations/domain/entities/specialization_entity.dart';
import 'package:medilink/features/specializations/domain/repositories/i_specialization_repository.dart';

class GetSpecializationByIdUsecase {
  final ISpecializationRepository _repository;

  GetSpecializationByIdUsecase(this._repository);

  Future<Either<Failure, SpecializationEntity>> call(String id) async {
    return await _repository.getSpecializationById(id);
  }
}
