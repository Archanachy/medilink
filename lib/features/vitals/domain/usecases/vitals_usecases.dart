import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/vitals/domain/entities/vitals_entity.dart';
import 'package:medilink/features/vitals/domain/repositories/i_vitals_repository.dart';

class GetVitalsUsecase {
  final IVitalsRepository _repository;

  GetVitalsUsecase(this._repository);

  Future<Either<Failure, List<VitalsEntity>>> call({String? vitalType}) async {
    return await _repository.getVitals(vitalType: vitalType);
  }
}

class GetVitalByIdUsecase {
  final IVitalsRepository _repository;

  GetVitalByIdUsecase(this._repository);

  Future<Either<Failure, VitalsEntity>> call(String id) async {
    return await _repository.getVitalById(id);
  }
}

class RecordVitalUsecase {
  final IVitalsRepository _repository;

  RecordVitalUsecase(this._repository);

  Future<Either<Failure, VitalsEntity>> call(VitalsEntity vital) async {
    return await _repository.recordVital(vital);
  }
}

class DeleteVitalUsecase {
  final IVitalsRepository _repository;

  DeleteVitalUsecase(this._repository);

  Future<Either<Failure, void>> call(String id) async {
    return await _repository.deleteVital(id);
  }
}

class GetVitalsByDateRangeUsecase {
  final IVitalsRepository _repository;

  GetVitalsByDateRangeUsecase(this._repository);

  Future<Either<Failure, List<VitalsEntity>>> call(
    DateTime startDate,
    DateTime endDate, {
    String? vitalType,
  }) async {
    return await _repository.getVitalsByDateRange(
      startDate,
      endDate,
      vitalType: vitalType,
    );
  }
}
