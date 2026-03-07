import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/features/specializations/data/datasources/specialization_local_data_source.dart';
import 'package:medilink/features/specializations/data/datasources/specialization_remote_data_source.dart';
import 'package:medilink/features/specializations/data/repositories/specialization_repository_impl.dart';
import 'package:medilink/features/specializations/domain/repositories/i_specialization_repository.dart';
import 'package:medilink/features/specializations/domain/usecases/get_specializations_usecase.dart';
import 'package:medilink/features/specializations/domain/usecases/get_specialization_by_id_usecase.dart';

// Data sources
final specializationRemoteDataSourceProvider = Provider<SpecializationRemoteDataSource>((ref) {
  return SpecializationRemoteDataSource(ref.watch(apiClientProvider));
});

final specializationLocalDataSourceProvider = Provider<SpecializationLocalDataSource>((ref) {
  return SpecializationLocalDataSource();
});

// Repository
final specializationRepositoryProvider = Provider<ISpecializationRepository>((ref) {
  return SpecializationRepositoryImpl(
    ref.watch(specializationRemoteDataSourceProvider),
    ref.watch(specializationLocalDataSourceProvider),
  );
});

// Use cases
final getSpecializationsUsecaseProvider = Provider<GetSpecializationsUsecase>((ref) {
  return GetSpecializationsUsecase(ref.watch(specializationRepositoryProvider));
});

final getSpecializationByIdUsecaseProvider = Provider<GetSpecializationByIdUsecase>((ref) {
  return GetSpecializationByIdUsecase(ref.watch(specializationRepositoryProvider));
});
