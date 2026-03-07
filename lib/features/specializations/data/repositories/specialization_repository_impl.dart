import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/specializations/data/datasources/specialization_local_data_source.dart';
import 'package:medilink/features/specializations/data/datasources/specialization_remote_data_source.dart';
import 'package:medilink/features/specializations/domain/entities/specialization_entity.dart';
import 'package:medilink/features/specializations/domain/repositories/i_specialization_repository.dart';

class SpecializationRepositoryImpl implements ISpecializationRepository {
  final SpecializationRemoteDataSource _remoteDataSource;
  final SpecializationLocalDataSource _localDataSource;

  SpecializationRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, List<SpecializationEntity>>> getSpecializations() async {
    try {
      // Try cache first
      final cachedSpecializations = await _localDataSource.getCachedSpecializations();
      if (cachedSpecializations != null && cachedSpecializations.isNotEmpty) {
        return Right(cachedSpecializations.map((model) => model.toEntity()).toList());
      }

      // Fetch from API
      final specializations = await _remoteDataSource.getSpecializations();
      
      // Cache the results
      await _localDataSource.cacheSpecializations(specializations);

      return Right(specializations.map((model) => model.toEntity()).toList());
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to fetch specializations: $e'));
    }
  }

  @override
  Future<Either<Failure, SpecializationEntity>> getSpecializationById(
      String id) async {
    try {
      // Try cache first
      final cachedSpecialization = await _localDataSource.getCachedSpecialization(id);
      if (cachedSpecialization != null) {
        return Right(cachedSpecialization.toEntity());
      }

      // Fetch from API
      final specialization = await _remoteDataSource.getSpecializationById(id);
      
      // Cache the result
      await _localDataSource.cacheSpecialization(specialization);

      return Right(specialization.toEntity());
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to fetch specialization: $e'));
    }
  }
}
