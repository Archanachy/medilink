import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/settings/domain/entities/settings_entity.dart';

abstract class ISettingsRepository {
  Future<Either<Failure, SettingsEntity>> getSettings();
  Future<Either<Failure, SettingsEntity>> updateSettings(SettingsEntity settings);
}
