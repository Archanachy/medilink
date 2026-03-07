import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/services/connectivity/network_info.dart';
import 'package:medilink/features/doctors/data/datasources/doctor_local_datasource.dart';
import 'package:medilink/features/doctors/data/datasources/doctor_remote_datasource.dart';
import 'package:medilink/features/doctors/data/models/doctor_api_model.dart';
import 'package:medilink/features/doctors/data/models/doctor_hive_model.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_entity.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_availability_entity.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_review_entity.dart';
import 'package:medilink/features/doctors/domain/repositories/doctor_repository.dart';

final doctorRepositoryProvider = Provider<IDoctorRepository>((ref) {
  final remote = ref.read(doctorRemoteDataSourceProvider);
  final local = ref.read(doctorLocalDatasourceProvider);
  final network = ref.read(networkInfoProvider);
  return DoctorRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: local,
    networkInfo: network,
  );
});

class DoctorRepositoryImpl implements IDoctorRepository {
  final DoctorRemoteDataSource _remoteDataSource;
  final DoctorLocalDatasource _localDataSource;
  final NetworkInfo _networkInfo;

  DoctorRepositoryImpl({
    required DoctorRemoteDataSource remoteDataSource,
    required DoctorLocalDatasource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<DoctorEntity>>> getDoctors({
    String? specialization,
    String? searchQuery,
    int? page,
    int? limit,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getDoctors(
          specialization: specialization,
          searchQuery: searchQuery,
          page: page,
          limit: limit,
        );
        final entities = DoctorApiModel.toEntityList(models);
        final hiveModels = entities
            .map((entity) => DoctorHiveModel.fromEntity(entity))
            .toList();
        await _localDataSource.cacheDoctors(hiveModels);
        return Right(entities);
      } on DioException {
        return const Left(ApiFailure(
            message: 'Failed to load doctors',
          ),
        );
      } catch (e) {
        return const Left(ApiFailure(message: 'Failed to load doctors'));
      }
    }

    try {
      final cached = await _localDataSource.getCachedDoctors();
      if (cached.isNotEmpty) {
        return Right(cached.map((model) => model.toEntity()).toList());
      }
      return const Left(NetworkFailure());
    } catch (e) {
      return const Left(LocalDatabaseFailure(message: 'Failed to load doctors'));
    }
  }

  @override
  Future<Either<Failure, DoctorEntity>> getDoctorById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getDoctorById(id);
        return Right(model.toEntity());
      } on DioException {
        return const Left(ApiFailure(
            message: 'Failed to load doctor',
          ),
        );
      } catch (e) {
        return const Left(ApiFailure(message: 'Failed to load doctor'));
      }
    }

    try {
      final cached = await _localDataSource.getDoctorById(id);
      if (cached != null) {
        return Right(cached.toEntity());
      }
      return const Left(NetworkFailure());
    } catch (e) {
      return const Left(LocalDatabaseFailure(message: 'Failed to load doctor'));
    }
  }

  @override
  Future<Either<Failure, DoctorAvailabilityEntity>> getDoctorAvailability(
    String doctorId,
    String date,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final data = await _remoteDataSource.getDoctorAvailability(doctorId, date);
      final entity = DoctorAvailabilityEntity(
        doctorId: doctorId,
        date: data['date'] as String? ?? date,
        availableSlots: (data['availableSlots'] as List<dynamic>? ?? [])
            .map((slot) => slot.toString())
            .toList(),
      );
      return Right(entity);
    } on DioException {
      return const Left(ApiFailure(
          message: 'Failed to load availability',
        ),
      );
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to load availability'));
    }
  }

  @override
  Future<Either<Failure, List<DoctorReviewEntity>>> getDoctorReviews(
    String doctorId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final data = await _remoteDataSource.getDoctorReviews(doctorId);
      final reviews = data.map(_mapReview).toList();
      return Right(reviews);
    } on DioException {
      return const Left(ApiFailure(
          message: 'Failed to load reviews',
        ),
      );
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to load reviews'));
    }
  }

  @override
  Future<Either<Failure, bool>> addDoctorReview(
    String doctorId,
    double rating,
    String? comment,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDataSource.addDoctorReview(
        doctorId,
        rating,
        comment,
      );
      return Right(result);
    } on DioException {
      return const Left(ApiFailure(
          message: 'Failed to submit review',
        ),
      );
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to submit review'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSpecializations() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final items = await _remoteDataSource.getSpecializations();
      return Right(items);
    } on DioException {
      return const Left(ApiFailure(
          message: 'Failed to load specializations',
        ),
      );
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to load specializations'));
    }
  }

  DoctorReviewEntity _mapReview(Map<String, dynamic> json) {
    final patient = json['patient'] as Map<String, dynamic>?;
    final patientId = json['patientId'] as String? ?? patient?['_id'] as String? ?? '';
    final patientName = json['patientName'] as String?
        ?? patient?['fullName'] as String?
        ?? patient?['name'] as String?
        ?? '';

    return DoctorReviewEntity(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      doctorId: json['doctorId'] as String? ?? '',
      patientId: patientId,
      patientName: patientName,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
