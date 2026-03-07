import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/services/connectivity/network_info.dart';
import 'package:medilink/features/appointments/data/datasources/appointment_local_datasource.dart';
import 'package:medilink/features/appointments/data/datasources/appointment_remote_datasource.dart';
import 'package:medilink/features/appointments/data/models/appointment_api_model.dart';
import 'package:medilink/features/appointments/data/models/appointment_hive_model.dart';
import 'package:medilink/features/appointments/domain/entities/appointment_entity.dart';
import 'package:medilink/features/appointments/domain/repositories/appointment_repository.dart';

final appointmentRepositoryProvider = Provider<IAppointmentRepository>((ref) {
  final remote = ref.read(appointmentRemoteDatasourceProvider);
  final local = ref.read(appointmentLocalDatasourceProvider);
  final network = ref.read(networkInfoProvider);

  return AppointmentRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: local,
    networkInfo: network,
  );
});

class AppointmentRepositoryImpl implements IAppointmentRepository {
  final AppointmentRemoteDatasource _remoteDataSource;
  final AppointmentLocalDatasource _localDataSource;
  final NetworkInfo _networkInfo;

  AppointmentRepositoryImpl({
    required AppointmentRemoteDatasource remoteDataSource,
    required AppointmentLocalDatasource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, AppointmentEntity>> bookAppointment({
    required String doctorId,
    required String patientId,
    required DateTime date,
    required String startTime,
    required String endTime,
    String? reason,
    String? symptoms,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final model = await _remoteDataSource.bookAppointment(
        doctorId: doctorId,
        patientId: patientId,
        date: date,
        startTime: startTime,
        endTime: endTime,
        reason: reason,
        symptoms: symptoms,
      );
      return Right(model.toEntity());
    } on DioException {
      return const Left(ApiFailure(
          message: 'Failed to book appointment',
        ),
      );
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to book appointment'));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getAppointments({
    String? userId,
    String? status,
    int? page,
    int? limit,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getAppointments(
          userId: userId,
          status: status,
          page: page,
          limit: limit,
        );
        final entities = AppointmentApiModel.toEntityList(models);
        final hiveModels = entities
            .map((entity) => AppointmentHiveModel.fromEntity(entity))
            .toList();
        await _localDataSource.cacheAppointments(hiveModels);
        return Right(entities);
      } on DioException {
        return const Left(ApiFailure(
            message: 'Failed to load appointments',
          ),
        );
      } catch (e) {
        return const Left(ApiFailure(message: 'Failed to load appointments'));
      }
    }

    try {
      final cached = await _localDataSource.getCachedAppointments();
      if (cached.isNotEmpty) {
        return Right(cached.map((model) => model.toEntity()).toList());
      }
      return const Left(NetworkFailure());
    } catch (e) {
      return const Left(LocalDatabaseFailure(message: 'Failed to load cached appointments'));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelAppointment({
    required String appointmentId,
    String? reason,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDataSource.cancelAppointment(
        appointmentId,
        reason: reason,
      );
      return Right(result);
    } on DioException {
      return const Left(
        ApiFailure(
          message: 'Failed to cancel appointment',
        ),
      );
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to cancel appointment'));
    }
  }
}
