import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/availability/domain/entities/availability_entity.dart';

abstract class IAvailabilityRepository {
  Future<Either<Failure, DoctorSchedule>> getDoctorSchedule(String doctorId,
      {DateTime? startDate, DateTime? endDate});
  Future<Either<Failure, List<AvailabilitySlot>>> getAvailableSlots(
      String doctorId, DateTime date);
  Future<Either<Failure, AvailabilitySlot>> createAvailabilitySlot(
      AvailabilitySlot slot);
  Future<Either<Failure, AvailabilitySlot>> updateAvailabilitySlot(
      AvailabilitySlot slot);
  Future<Either<Failure, void>> deleteAvailabilitySlot(String slotId);
  Future<Either<Failure, void>> addHoliday(
      String doctorId, DateTime date, String reason);
  Future<Either<Failure, void>> removeHoliday(String doctorId, DateTime date);
}
