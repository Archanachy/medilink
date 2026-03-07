import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:medilink/features/settings/data/models/settings_api_model.dart';
import 'package:medilink/features/settings/domain/entities/settings_entity.dart';
import 'package:medilink/features/settings/domain/repositories/i_settings_repository.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  final SettingsRemoteDataSource _remoteDataSource;

  SettingsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, SettingsEntity>> getSettings() async {
    try {
      final settings = await _remoteDataSource.getSettings();
      return Right(settings.toEntity());
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to fetch settings: $e'));
    }
  }

  @override
  Future<Either<Failure, SettingsEntity>> updateSettings(
      SettingsEntity settings) async {
    try {
      final model = SettingsApiModel.fromEntity(settings);
      final updatedSettings = await _remoteDataSource.updateSettings(model);
      return Right(updatedSettings.toEntity());
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to update settings: $e'));
    }
  }
}
