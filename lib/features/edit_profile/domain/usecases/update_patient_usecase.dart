import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/edit_profile/domain/enitities/user_profile_entity.dart';
import 'package:medilink/features/edit_profile/domain/repositories/patient_repository.dart';
import 'package:medilink/features/edit_profile/data/repositories/patient_repository_impl.dart';

class UpdatePatientParams {
  final String patientId;
  final UserProfileEntity patient;
  final File? profileImage;

  UpdatePatientParams({
    required this.patientId,
    required this.patient,
    this.profileImage,
  });
}

final updatePatientUsecaseProvider = Provider<UpdatePatientUsecase>((ref) {
  final repo = ref.read(patientRepositoryProvider);
  return UpdatePatientUsecase(repo);
});

class UpdatePatientUsecase
    implements UsecaseWithParams<UserProfileEntity, UpdatePatientParams> {
  final IPatientRepository _repository;

  UpdatePatientUsecase(this._repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call(UpdatePatientParams params) {
    return _repository.updatePatient(
      patientId: params.patientId,
      patient: params.patient,
      profileImage: params.profileImage,
    );
  }
}
