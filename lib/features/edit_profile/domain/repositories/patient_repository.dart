import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/edit_profile/domain/enitities/user_profile_entity.dart';

abstract interface class IPatientRepository {
  Future<Either<Failure, UserProfileEntity>> getPatientByUserId(String userId);
  Future<Either<Failure, UserProfileEntity>> updatePatient({
    required String patientId,
    required UserProfileEntity patient,
    File? profileImage,
  });
}
