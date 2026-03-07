import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/availability/domain/entities/availability_entity.dart';
import 'package:medilink/features/availability/domain/repositories/i_availability_repository.dart';

class GetDoctorScheduleUsecase {
  final IAvailabilityRepository _repository;

  GetDoctorScheduleUsecase(this._repository);

  Future<Either<Failure, DoctorSchedule>> call(
    String doctorId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _repository.getDoctorSchedule(
      doctorId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

class GetAvailableSlotsUsecase {
  final IAvailabilityRepository _repository;

  GetAvailableSlotsUsecase(this._repository);

  Future<Either<Failure, List<AvailabilitySlot>>> call(
      String doctorId, DateTime date) async {
    return await _repository.getAvailableSlots(doctorId, date);
  }
}

class CreateAvailabilitySlotUsecase {
  final IAvailabilityRepository _repository;

  CreateAvailabilitySlotUsecase(this._repository);

  Future<Either<Failure, AvailabilitySlot>> call(AvailabilitySlot slot) async {
    return await _repository.createAvailabilitySlot(slot);
  }
}

class UpdateAvailabilitySlotUsecase {
  final IAvailabilityRepository _repository;

  UpdateAvailabilitySlotUsecase(this._repository);

  Future<Either<Failure, AvailabilitySlot>> call(AvailabilitySlot slot) async {
    return await _repository.updateAvailabilitySlot(slot);
  }
}

class DeleteAvailabilitySlotUsecase {
  final IAvailabilityRepository _repository;

  DeleteAvailabilitySlotUsecase(this._repository);

  Future<Either<Failure, void>> call(String slotId) async {
    return await _repository.deleteAvailabilitySlot(slotId);
  }
}

class AddHolidayUsecase {
  final IAvailabilityRepository _repository;

  AddHolidayUsecase(this._repository);

  Future<Either<Failure, void>> call(
      String doctorId, DateTime date, String reason) async {
    return await _repository.addHoliday(doctorId, date, reason);
  }
}
