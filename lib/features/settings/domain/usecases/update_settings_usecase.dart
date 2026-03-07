import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/settings/domain/entities/settings_entity.dart';
import 'package:medilink/features/settings/domain/repositories/i_settings_repository.dart';

class UpdateSettingsUsecase {
  final ISettingsRepository _repository;

  UpdateSettingsUsecase(this._repository);

  Future<Either<Failure, SettingsEntity>> call(SettingsEntity settings) async {
    return await _repository.updateSettings(settings);
  }
}
