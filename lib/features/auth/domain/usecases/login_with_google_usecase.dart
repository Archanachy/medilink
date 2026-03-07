import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/auth/data/repositories/auth_repository.dart';
import 'package:medilink/features/auth/domain/enitities/auth_entity.dart';
import 'package:medilink/features/auth/domain/repositories/auth_repository.dart';

class LoginWithGoogleParams extends Equatable {
  final String idToken;
  const LoginWithGoogleParams({required this.idToken});
  
  @override
  List<Object?> get props => [idToken];
}

final loginWithGoogleUsecaseProvider = Provider<LoginWithGoogleUsecase>((ref) {
  return LoginWithGoogleUsecase(ref.read(authRepositoryProvider));
});

class LoginWithGoogleUsecase implements UsecaseWithParams<AuthEntity, LoginWithGoogleParams> {
  final IAuthRepository _repository;
  
  LoginWithGoogleUsecase(this._repository);
  
  @override
  Future<Either<Failure, AuthEntity>> call(LoginWithGoogleParams params) {
    return _repository.loginWithGoogle(params.idToken);
  }
}
