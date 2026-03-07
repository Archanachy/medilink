import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/availability/data/datasources/availability_remote_data_source.dart';
import 'package:medilink/features/availability/data/models/availability_api_model.dart';
import 'package:medilink/features/availability/domain/entities/availability_entity.dart';
import 'package:medilink/features/availability/domain/repositories/i_availability_repository.dart';

class AvailabilityRepositoryImpl implements IAvailabilityRepository {
  final AvailabilityRemoteDataSource _remoteDataSource;

  AvailabilityRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DoctorSchedule>> getDoctorSchedule(
    String doctorId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final schedule = await _remoteDataSource.getDoctorSchedule(
        doctorId,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(schedule.toEntity());
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to fetch doctor schedule'));
    }
  }

  @override
  Future<Either<Failure, List<AvailabilitySlot>>> getAvailableSlots(
      String doctorId, DateTime date) async {
    try {
      final slots = await _remoteDataSource.getAvailableSlots(doctorId, date);
      return Right(slots.map((s) => s.toEntity()).toList());
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to fetch available slots'));
    }
  }

  @override
  Future<Either<Failure, AvailabilitySlot>> createAvailabilitySlot(
      AvailabilitySlot slot) async {
    try {
      final model = AvailabilitySlotApiModel.fromEntity(slot);
      final createdSlot = await _remoteDataSource.createAvailabilitySlot(model);
      return Right(createdSlot.toEntity());
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to create availability slot'));
    }
  }

  @override
  Future<Either<Failure, AvailabilitySlot>> updateAvailabilitySlot(
      AvailabilitySlot slot) async {
    try {
      final model = AvailabilitySlotApiModel.fromEntity(slot);
      final updatedSlot = await _remoteDataSource.updateAvailabilitySlot(model);
      return Right(updatedSlot.toEntity());
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to update availability slot'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAvailabilitySlot(String slotId) async {
    try {
      await _remoteDataSource.deleteAvailabilitySlot(slotId);
      return const Right(null);
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to delete availability slot'));
    }
  }

  @override
  Future<Either<Failure, void>> addHoliday(
      String doctorId, DateTime date, String reason) async {
    try {
      await _remoteDataSource.addHoliday(doctorId, date, reason);
      return const Right(null);
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to add holiday'));
    }
  }

  @override
  Future<Either<Failure, void>> removeHoliday(
      String doctorId, DateTime date) async {
    try {
      await _remoteDataSource.removeHoliday(doctorId, date);
      return const Right(null);
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to remove holiday'));
    }
  }
}
