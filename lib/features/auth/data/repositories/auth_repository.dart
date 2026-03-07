import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/services/connectivity/network_info.dart';
import 'package:medilink/features/auth/data/datasources/auth_datasource.dart';
import 'package:medilink/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:medilink/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:medilink/features/auth/data/models/auth_api_model.dart';
import 'package:medilink/features/auth/data/models/auth_hive_model.dart';
import 'package:medilink/features/auth/domain/enitities/auth_entity.dart';
import 'package:medilink/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDatasource = ref.read(authLocalDatasourceProvider);
  final authRemoteDatasource = ref.read(authRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return AuthRepository(
    authDatasource: authDatasource,
    authRemoteDataSource: authRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDatasource _authDatasource;
  final IAuthRemoteDatasource _authRemoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthLocalDatasource authDatasource,
    required IAuthRemoteDatasource authRemoteDataSource,
    required NetworkInfo networkInfo,
  })  : _authDatasource = authDatasource,
        _authRemoteDataSource = authRemoteDataSource,
        _networkInfo = networkInfo;

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
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDataSource.login(email, password);
        if (apiModel != null) {
          final entity = apiModel.toEntity();
          return Right(entity);
        }
        return const Left(ApiFailure(message: 'Invalid credentials'));
      } on DioException {
        return const Left(ApiFailure(message: 'Login failed'));
      } catch (e) {
        return const Left(ApiFailure(message: 'Login failed'));
      }
    } else {
      try {
        final model = await _authDatasource.login(email, password);
        if (model != null) {
          final entity = model.toEntity();
          return Right(entity);
        }
        return const Left(LocalDatabaseFailure(message: 'Invalid email or password'));
      } catch (e) {
        return const Left(LocalDatabaseFailure(message: 'Login failed'));
      }
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
      return const Left(LocalDatabaseFailure(message: 'Logout failed'));
    }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity user) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(user);
        await _authRemoteDataSource.register(apiModel);
        return const Right(true);
      } on DioException {
        return const Left(ApiFailure(message: 'Registration failed'));
      } catch (e) {
        return const Left(ApiFailure(message: 'Registration failed'));
      }
    } else {
      try {
        final existingUser = await _authDatasource.isEmailExists(user.email);
        if (existingUser) {
          return const Left(LocalDatabaseFailure(message: "Email already registered"));
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
        return const Left(LocalDatabaseFailure(message: 'Registration failed'));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> forgotPassword(String email) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _authRemoteDataSource.forgotPassword(email);
        return Right(result);
      } on DioException {
        return const Left(ApiFailure(message: 'Failed to send reset email'));
      } catch (e) {
        return const Left(ApiFailure(message: 'Failed to send reset email'));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword(String token, String newPassword) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _authRemoteDataSource.resetPassword(token, newPassword);
        return Right(result);
      } on DioException {
        return const Left(ApiFailure(message: 'Failed to reset password'));
      } catch (e) {
        return const Left(ApiFailure(message: 'Failed to reset password'));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> verifyEmail(String token) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _authRemoteDataSource.verifyEmail(token);
        return Right(result);
      } on DioException {
        return const Left(ApiFailure(message: 'Email verification failed'));
      } catch (e) {
        return const Left(ApiFailure(message: 'Email verification failed'));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken(String refreshToken) async {
    if (await _networkInfo.isConnected) {
      try {
        final newToken = await _authRemoteDataSource.refreshToken(refreshToken);
        return Right(newToken);
      } on DioException {
        return const Left(ApiFailure(message: 'Token refresh failed'));
      } catch (e) {
        return const Left(ApiFailure(message: 'Token refresh failed'));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> loginWithGoogle(String idToken) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDataSource.loginWithGoogle(idToken);
        if (apiModel != null) {
          final entity = apiModel.toEntity();
          return Right(entity);
        }
        return const Left(ApiFailure(message: 'Google login failed'));
      } on DioException {
        return const Left(ApiFailure(message: 'Google login failed'));
      } catch (e) {
        return const Left(ApiFailure(message: 'Google login failed'));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> loginWithApple(String authorizationCode) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDataSource.loginWithApple(authorizationCode);
        if (apiModel != null) {
          final entity = apiModel.toEntity();
          return Right(entity);
        }
        return const Left(ApiFailure(message: 'Apple login failed'));
      } on DioException {
        return const Left(ApiFailure(message: 'Apple login failed'));
      } catch (e) {
        return const Left(ApiFailure(message: 'Apple login failed'));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
