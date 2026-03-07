import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/features/vitals/data/datasources/vitals_local_data_source.dart';
import 'package:medilink/features/vitals/data/datasources/vitals_remote_data_source.dart';
import 'package:medilink/features/vitals/data/repositories/vitals_repository_impl.dart';
import 'package:medilink/features/vitals/domain/repositories/i_vitals_repository.dart';
import 'package:medilink/features/vitals/domain/usecases/vitals_usecases.dart';

// Data sources
final vitalsRemoteDataSourceProvider = Provider<VitalsRemoteDataSource>((ref) {
  return VitalsRemoteDataSource(ref.watch(apiClientProvider));
});

final vitalsLocalDataSourceProvider = Provider<VitalsLocalDataSource>((ref) {
  return VitalsLocalDataSource();
});

// Repository
final vitalsRepositoryProvider = Provider<IVitalsRepository>((ref) {
  return VitalsRepositoryImpl(
    ref.watch(vitalsRemoteDataSourceProvider),
    ref.watch(vitalsLocalDataSourceProvider),
  );
});

// Use cases
final getVitalsUsecaseProvider = Provider<GetVitalsUsecase>((ref) {
  return GetVitalsUsecase(ref.watch(vitalsRepositoryProvider));
});

final getVitalByIdUsecaseProvider = Provider<GetVitalByIdUsecase>((ref) {
  return GetVitalByIdUsecase(ref.watch(vitalsRepositoryProvider));
});

final recordVitalUsecaseProvider = Provider<RecordVitalUsecase>((ref) {
  return RecordVitalUsecase(ref.watch(vitalsRepositoryProvider));
});

final deleteVitalUsecaseProvider = Provider<DeleteVitalUsecase>((ref) {
  return DeleteVitalUsecase(ref.watch(vitalsRepositoryProvider));
});

final getVitalsByDateRangeUsecaseProvider =
    Provider<GetVitalsByDateRangeUsecase>((ref) {
  return GetVitalsByDateRangeUsecase(ref.watch(vitalsRepositoryProvider));
});
