

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/auth/data/repositories/auth_repository.dart';
import 'package:medilink/features/auth/domain/enitities/auth_enitity.dart';
import 'package:medilink/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecaseParams extends Equatable {
  final String userName;
  final String password;

  const LoginUsecaseParams({
    required this.userName,
    required this.password,
  });

  @override
  List<Object?> get props => [userName, password];
}

// provider for loginUsecase
final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginUsecase(authRepository: authRepository);
});

class LoginUsecase  implements UsecaseWithParams<AuthEnitity, LoginUsecaseParams>{
  final IAuthRepository _authRepository;
  LoginUsecase({required IAuthRepository authRepository})
  : _authRepository = authRepository;
  
  
  @override
  Future<Either<Failure, AuthEnitity>> call(LoginUsecaseParams params) {
    
    return _authRepository.login(params.userName, params.password);
  }

}