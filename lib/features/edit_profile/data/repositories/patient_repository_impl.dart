import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/services/connectivity/network_info.dart';
import 'package:medilink/features/edit_profile/data/datasources/patient_remote_datasource.dart';
import 'package:medilink/features/edit_profile/data/models/patient_api_model.dart';
import 'package:medilink/features/edit_profile/domain/enitities/user_profile_entity.dart';
import 'package:medilink/features/edit_profile/domain/repositories/patient_repository.dart';

final patientRepositoryProvider = Provider<IPatientRepository>((ref) {
  final remote = ref.read(patientRemoteDatasourceProvider);
  final network = ref.read(networkInfoProvider);
  return PatientRepository(remote: remote, networkInfo: network);
});

class PatientRepository implements IPatientRepository {
  final PatientRemoteDatasource _remote;
  final NetworkInfo _networkInfo;

  PatientRepository({required PatientRemoteDatasource remote, required NetworkInfo networkInfo})
      : _remote = remote,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, UserProfileEntity>> getPatientByUserId(String userId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
    try {
      final model = await _remote.getPatientByUserId(userId);
      // email/username come from user endpoint; keep empty here
      return Right(model.toEntity(email: '', userName: ''));
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to load patient'));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updatePatient({
    required String patientId,
    required UserProfileEntity patient,
    File? profileImage,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
    try {
      final model = PatientApiModel(
        id: patientId,
        userId: patient.userId ?? '',
        firstName: patient.firstName,
        lastName: patient.lastName,
        phone: patient.phoneNumber,
        dateOfBirth: patient.dateOfBirth,
        gender: patient.gender,
        bloodGroup: patient.bloodGroup,
        address: patient.address,
      );
      final updated = await _remote.updatePatient(
        patientId: patientId,
        payload: model,
        profileImage: profileImage,
      );
      return Right(updated.toEntity(email: patient.email, userName: patient.userName));
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to update patient'));
    }
  }
}
