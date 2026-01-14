import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/auth/data/datasources/auth_datasource.dart';
import 'package:medilink/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:medilink/features/auth/data/models/auth_hive_model.dart';
import 'package:medilink/features/auth/domain/enitities/auth_entity.dart';
import 'package:medilink/features/auth/domain/repositories/auth_repository.dart';

//provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(authDatasource: ref.watch(authLocalDatasourceProvider));
});

class AuthRepository  implements IAuthRepository{
  final IAuthLocalDatasource _authDatasource;

  AuthRepository({required IAuthLocalDatasource authDatasource})
  : _authDatasource = authDatasource;

  @override
  Future<Either<Failure, bool>> register(AuthEntity user) async {
    try {
      // Check if email already exists
      final existingUser = await _authDatasource.isEmailExists(user.email);
      if (existingUser) {
        return const Left(
          LocalDatabaseFailure(message: "Email already registered"),
        );
      }

      final authModel = AuthHiveModel(
        fullName: user.fullName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        userName: user.userName,
        password: user.password,
        profilePicture: user.profilePicture,
      );
      await _authDatasource.register(authModel);
      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final model = await _authDatasource.login(email, password);
      if (model != null) {
        final entity = model.toEntity();
        return Right(entity);
      }
      return const Left(
        LocalDatabaseFailure(message: "Invalid email or password"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final model = await _authDatasource.getCurrentUser();
      if (model != null) {
        final entity = model.toEntity();
        return Right(entity);
      }
      return const Left(LocalDatabaseFailure(message: "No user logged in"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authDatasource.logout();
      if (result) {
        return const Right(true);
      }
      return const Left(LocalDatabaseFailure(message: "Failed to logout"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}