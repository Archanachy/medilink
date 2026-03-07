import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/services/connectivity/network_info.dart';
import 'package:medilink/features/edit_profile/data/datasources/profile_remote_datasource.dart';
import 'package:medilink/features/edit_profile/data/models/user_profile_api_model.dart';
import 'package:medilink/features/edit_profile/domain/enitities/user_profile_entity.dart';
import 'package:medilink/features/edit_profile/domain/repositories/user_profile_repository.dart';

final userProfileRepositoryProvider = Provider<IUserProfileRepository>((ref) {
  final remoteDatasource = ref.read(profileRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return UserProfileRepository(
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class UserProfileRepository implements IUserProfileRepository {
  final ProfileRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  UserProfileRepository({
    required ProfileRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  })  : _remoteDatasource = remoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile() async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'No internet connection'),
      );
    }

    try {
      final apiModel = await _remoteDatasource.getUserProfile();
      return Right(apiModel.toEntity());
    } on DioException {
      return const Left(ApiFailure(
          message: 'Failed to load profile',
        ),
      );
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to load profile'));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateProfile(
    UserProfileEntity profile,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'No internet connection'),
      );
    }

    try {
      final apiModel = UserProfileApiModel.fromEntity(profile);
      final updatedModel = await _remoteDatasource.updateProfile(apiModel);
      return Right(updatedModel.toEntity());
    } on DioException {
      return const Left(ApiFailure(
          message: 'Failed to update profile',
        ),
      );
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to update profile'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File imageFile) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'No internet connection'),
      );
    }

    try {
      final photoUrl = await _remoteDatasource.uploadProfilePicture(imageFile);
      return Right(photoUrl);
    } on DioException {
      return const Left(ApiFailure(
          message: 'Failed to upload photo',
        ),
      );
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to upload photo'));
    }
  }
}
