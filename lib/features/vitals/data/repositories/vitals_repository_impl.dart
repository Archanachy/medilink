import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/vitals/data/datasources/vitals_local_data_source.dart';
import 'package:medilink/features/vitals/data/datasources/vitals_remote_data_source.dart';
import 'package:medilink/features/vitals/data/models/vitals_api_model.dart';
import 'package:medilink/features/vitals/domain/entities/vitals_entity.dart';
import 'package:medilink/features/vitals/domain/repositories/i_vitals_repository.dart';

class VitalsRepositoryImpl implements IVitalsRepository {
  final VitalsRemoteDataSource _remoteDataSource;
  final VitalsLocalDataSource _localDataSource;

  VitalsRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, List<VitalsEntity>>> getVitals(
      {String? vitalType}) async {
    try {
      // Try cache first
      final cachedVitals = await _localDataSource.getCachedVitals();
      if (cachedVitals != null && vitalType == null) {
        return Right(cachedVitals.map((v) => v.toEntity()).toList());
      }

      // Fetch from API
      final vitals = await _remoteDataSource.getVitals(vitalType: vitalType);

      // Cache if no type filter
      if (vitalType == null) {
        await _localDataSource.cacheVitals(vitals);
      }

      return Right(vitals.map((v) => v.toEntity()).toList());
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to fetch vitals: $e'));
    }
  }

  @override
  Future<Either<Failure, VitalsEntity>> getVitalById(String id) async {
    try {
      final vital = await _remoteDataSource.getVitalById(id);
      return Right(vital.toEntity());
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to fetch vital: $e'));
    }
  }

  @override
  Future<Either<Failure, VitalsEntity>> recordVital(VitalsEntity vital) async {
    try {
      final model = VitalsApiModel.fromEntity(vital);
      final recorded = await _remoteDataSource.recordVital(model);

      // Clear cache to force refresh
      await _localDataSource.clearCache();

      return Right(recorded.toEntity());
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to record vital: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVital(String id) async {
    try {
      await _remoteDataSource.deleteVital(id);

      // Clear cache
      await _localDataSource.clearCache();

      return const Right(null);
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to delete vital: $e'));
    }
  }

  @override
  Future<Either<Failure, List<VitalsEntity>>> getVitalsByDateRange(
    DateTime startDate,
    DateTime endDate, {
    String? vitalType,
  }) async {
    try {
      final vitals = await _remoteDataSource.getVitalsByDateRange(
        startDate,
        endDate,
        vitalType: vitalType,
      );
      return Right(vitals.map((v) => v.toEntity()).toList());
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(
          ApiFailure(message: 'Failed to fetch vitals by date range: $e'));
    }
  }
}
