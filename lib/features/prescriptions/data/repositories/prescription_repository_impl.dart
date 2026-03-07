import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/prescriptions/data/data_source/local/prescription_local_data_source.dart';
import 'package:medilink/features/prescriptions/data/data_source/remote/prescription_remote_data_source.dart';
import 'package:medilink/features/prescriptions/data/models/prescription_api_model.dart';
import 'package:medilink/features/prescriptions/data/models/prescription_hive_model.dart';
import 'package:medilink/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:medilink/features/prescriptions/domain/repositories/i_prescription_repository.dart';

class PrescriptionRepository implements IPrescriptionRepository {
  final IPrescriptionRemoteDataSource remoteDataSource;
  final IPrescriptionLocalDataSource localDataSource;

  PrescriptionRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<PrescriptionEntity>>> getPrescriptions(
    String patientId,
  ) async {
    try {
      // Try remote first
      final prescriptions = await remoteDataSource.getPrescriptions(patientId);
      final entities = prescriptions.map((e) => e.toEntity()).toList();

      // Cache for offline use
      await localDataSource.cachePrescriptions(
        prescriptions
            .map((e) => PrescriptionHiveModel.fromEntity(e.toEntity()))
            .toList(),
      );

      return Right(entities);
    } catch (e) {
      // Fallback to local cache
      try {
        final cached = await localDataSource.getPrescriptions();
        final entities = cached.map((e) => e.toEntity()).toList();
        return Right(entities);
      } catch (localError) {
        return const Left(ApiFailure(message: 'Failed to load prescriptions'));
      }
    }
  }

  @override
  Future<Either<Failure, PrescriptionEntity>> getPrescriptionById(
    String id,
  ) async {
    try {
      // Try remote first
      final prescription = await remoteDataSource.getPrescriptionById(id);
      final entity = prescription.toEntity();

      // Cache for offline use
      await localDataSource.cachePrescription(
        PrescriptionHiveModel.fromEntity(entity),
      );

      return Right(entity);
    } catch (e) {
      // Fallback to local cache
      try {
        final cached = await localDataSource.getPrescriptionById(id);
        if (cached != null && cached.id.isNotEmpty) {
          return Right(cached.toEntity());
        }
        return const Left(ApiFailure(message: 'Prescription not found'));
      } catch (localError) {
        return const Left(ApiFailure(message: 'Failed to load prescription'));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> createPrescription(
    PrescriptionEntity prescription,
  ) async {
    try {
      final apiModel = PrescriptionApiModel.fromEntity(prescription);
      final success = await remoteDataSource.createPrescription(apiModel);

      if (success) {
        // Cache the created prescription
        await localDataSource.cachePrescription(
          PrescriptionHiveModel.fromEntity(prescription),
        );
      }

      return Right(success);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to create prescription'));
    }
  }

  @override
  Future<Either<Failure, bool>> updatePrescription(
    PrescriptionEntity prescription,
  ) async {
    try {
      final apiModel = PrescriptionApiModel.fromEntity(prescription);
      final success = await remoteDataSource.updatePrescription(apiModel);

      if (success) {
        // Update cache
        await localDataSource.cachePrescription(
          PrescriptionHiveModel.fromEntity(prescription),
        );
      }

      return Right(success);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to update prescription'));
    }
  }
}
