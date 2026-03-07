import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/settings/domain/entities/settings_entity.dart';
import 'package:medilink/features/settings/domain/repositories/i_settings_repository.dart';

class GetSettingsUsecase {
  final ISettingsRepository _repository;

  GetSettingsUsecase(this._repository);

  Future<Either<Failure, SettingsEntity>> call() async {
    return await _repository.getSettings();
  }
}
