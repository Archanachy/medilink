import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/features/availability/data/datasources/availability_remote_data_source.dart';
import 'package:medilink/features/availability/data/repositories/availability_repository_impl.dart';
import 'package:medilink/features/availability/domain/repositories/i_availability_repository.dart';
import 'package:medilink/features/availability/domain/usecases/availability_usecases.dart';

// Data source
final availabilityRemoteDataSourceProvider =
    Provider<AvailabilityRemoteDataSource>((ref) {
  return AvailabilityRemoteDataSource(ref.watch(apiClientProvider));
});

// Repository
final availabilityRepositoryProvider = Provider<IAvailabilityRepository>((ref) {
  return AvailabilityRepositoryImpl(
      ref.watch(availabilityRemoteDataSourceProvider));
});

// Use cases
final getDoctorScheduleUsecaseProvider = Provider<GetDoctorScheduleUsecase>((ref) {
  return GetDoctorScheduleUsecase(ref.watch(availabilityRepositoryProvider));
});

final getAvailableSlotsUsecaseProvider = Provider<GetAvailableSlotsUsecase>((ref) {
  return GetAvailableSlotsUsecase(ref.watch(availabilityRepositoryProvider));
});

final createAvailabilitySlotUsecaseProvider =
    Provider<CreateAvailabilitySlotUsecase>((ref) {
  return CreateAvailabilitySlotUsecase(
      ref.watch(availabilityRepositoryProvider));
});

final updateAvailabilitySlotUsecaseProvider =
    Provider<UpdateAvailabilitySlotUsecase>((ref) {
  return UpdateAvailabilitySlotUsecase(
      ref.watch(availabilityRepositoryProvider));
});

final deleteAvailabilitySlotUsecaseProvider =
    Provider<DeleteAvailabilitySlotUsecase>((ref) {
  return DeleteAvailabilitySlotUsecase(
      ref.watch(availabilityRepositoryProvider));
});

final addHolidayUsecaseProvider = Provider<AddHolidayUsecase>((ref) {
  return AddHolidayUsecase(ref.watch(availabilityRepositoryProvider));
});
