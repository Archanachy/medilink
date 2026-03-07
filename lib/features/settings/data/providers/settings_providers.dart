import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:medilink/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:medilink/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:medilink/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:medilink/features/settings/domain/usecases/update_settings_usecase.dart';

// Data source
final settingsRemoteDataSourceProvider = Provider<SettingsRemoteDataSource>((ref) {
  return SettingsRemoteDataSource(ref.watch(apiClientProvider));
});

// Repository
final settingsRepositoryProvider = Provider<ISettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.watch(settingsRemoteDataSourceProvider));
});

// Use cases
final getSettingsUsecaseProvider = Provider<GetSettingsUsecase>((ref) {
  return GetSettingsUsecase(ref.watch(settingsRepositoryProvider));
});

final updateSettingsUsecaseProvider = Provider<UpdateSettingsUsecase>((ref) {
  return UpdateSettingsUsecase(ref.watch(settingsRepositoryProvider));
});
