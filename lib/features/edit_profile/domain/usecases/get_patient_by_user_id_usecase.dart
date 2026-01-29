import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/edit_profile/domain/enitities/user_profile_entity.dart';
import 'package:medilink/features/edit_profile/domain/repositories/patient_repository.dart';
import 'package:medilink/features/edit_profile/data/repositories/patient_repository_impl.dart';

final getPatientByUserIdUsecaseProvider = Provider<GetPatientByUserIdUsecase>((ref) {
  final repo = ref.read(patientRepositoryProvider);
  return GetPatientByUserIdUsecase(repo);
});

class GetPatientByUserIdUsecase
    implements UsecaseWithParams<UserProfileEntity, String> {
  final IPatientRepository _repository;

  GetPatientByUserIdUsecase(this._repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call(String userId) {
    return _repository.getPatientByUserId(userId);
  }
}
