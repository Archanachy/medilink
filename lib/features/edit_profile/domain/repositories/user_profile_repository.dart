import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/edit_profile/domain/enitities/user_profile_entity.dart';

abstract interface class IUserProfileRepository {
  Future<Either<Failure, UserProfileEntity>> getUserProfile();
  Future<Either<Failure, UserProfileEntity>> updateProfile(UserProfileEntity profile);
  Future<Either<Failure, String>> uploadProfilePicture(File imageFile);
}
