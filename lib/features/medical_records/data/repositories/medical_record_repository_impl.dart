import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/services/connectivity/network_info.dart';
import 'package:medilink/features/medical_records/data/datasources/medical_record_local_datasource.dart';
import 'package:medilink/features/medical_records/data/datasources/medical_record_remote_datasource.dart';
import 'package:medilink/features/medical_records/data/models/medical_record_api_model.dart';
import 'package:medilink/features/medical_records/data/models/medical_record_hive_model.dart';
import 'package:medilink/features/medical_records/domain/entities/medical_record_entity.dart';
import 'package:medilink/features/medical_records/domain/repositories/medical_record_repository.dart';

final medicalRecordRepositoryProvider = Provider<IMedicalRecordRepository>((ref) {
  final remote = ref.read(medicalRecordRemoteDatasourceProvider);
  final local = ref.read(medicalRecordLocalDatasourceProvider);
  final network = ref.read(networkInfoProvider);

  return MedicalRecordRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: local,
    networkInfo: network,
  );
});

class MedicalRecordRepositoryImpl implements IMedicalRecordRepository {
  final MedicalRecordRemoteDatasource _remoteDataSource;
  final MedicalRecordLocalDatasource _localDataSource;
  final NetworkInfo _networkInfo;

  MedicalRecordRepositoryImpl({
    required MedicalRecordRemoteDatasource remoteDataSource,
    required MedicalRecordLocalDatasource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, MedicalRecordEntity>> uploadRecord({
    required String patientId,
    String? doctorId,
    required String title,
    required String type,
    required String filePath,
    String? notes,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final model = await _remoteDataSource.uploadRecord(
        patientId: patientId,
        doctorId: doctorId,
        title: title,
        type: type,
        filePath: filePath,
        notes: notes,
      );
      return Right(model.toEntity());
    } on DioException {
      return const Left(ApiFailure(
          message: 'Failed to upload record',
        ),
      );
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to upload record'));
    }
  }

  @override
  Future<Either<Failure, List<MedicalRecordEntity>>> getRecords({
    required String patientId,
    int? page,
    int? limit,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getRecords(
          patientId: patientId,
          page: page,
          limit: limit,
        );
        final entities = MedicalRecordApiModel.toEntityList(models);
        final hiveModels = entities
            .map((entity) => MedicalRecordHiveModel.fromEntity(entity))
            .toList();
        await _localDataSource.cacheRecords(hiveModels);
        return Right(entities);
      } on DioException {
        return const Left(ApiFailure(
            message: 'Failed to load records',
          ),
        );
      } catch (e) {
        return const Left(ApiFailure(message: 'Failed to load records'));
      }
    }

    try {
      final cached = await _localDataSource.getCachedRecords();
      if (cached.isNotEmpty) {
        return Right(cached.map((model) => model.toEntity()).toList());
      }
      return const Left(NetworkFailure());
    } catch (e) {
      return const Left(LocalDatabaseFailure(message: 'Failed to load records'));
    }
  }
}
