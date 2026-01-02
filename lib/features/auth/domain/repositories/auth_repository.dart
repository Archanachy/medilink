
import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/auth/domain/enitities/auth_enitity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure,bool>> register(AuthEnitity entity);

  Future<Either<Failure,AuthEnitity>> login(String email, String password);

  Future<Either<Failure,AuthEnitity>> getCurrentUser();
  Future<Either<Failure,bool>> logout();
}