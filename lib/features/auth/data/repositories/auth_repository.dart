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
  final IAuthDatasource _authDatasource;

  AuthRepository({required IAuthDatasource authDatasource})
  : _authDatasource = authDatasource;

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    try{
      // convert to model
      final model = AuthHiveModel.fromEntity(entity);
      final result = await _authDatasource.register(model);
      if(result){
        return const Right(true);
      }
      return const Left(LocalDatabaseFailure(message: 'Failed to register user'));
    }catch(e){
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(String email, String password) async {
    try{
      final user = await _authDatasource.login(email, password);
      if(user != null){
        final entity = user.toEntity();
        return Right(entity);
      }
      return Left(LocalDatabaseFailure(message: "Invalid credentials"));
      
    }catch(e){
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try{
      final user = await _authDatasource.getCurrentUser();
      if(user != null){
        final entity = user.toEntity();
        return Right(entity);
      }
      return Left(LocalDatabaseFailure(message: "No user found"));
    }catch(e){
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try{
      final result = await _authDatasource.logout();
      if(result){
        return Right(true);
      }
      return Left(LocalDatabaseFailure(message: "Failed to logout user"));
    }catch(e){
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}