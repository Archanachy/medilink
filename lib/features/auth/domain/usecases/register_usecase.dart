

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/auth/data/repositories/auth_repository.dart';
import 'package:medilink/features/auth/domain/enitities/auth_entity.dart';
import 'package:medilink/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecaseParams extends Equatable {
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String userName;
  final String password;

  const RegisterUsecaseParams({
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.userName,
    required this.password,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [fullName, email, phoneNumber, userName, password];
}

// provider for registerUsecase
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase  implements UsecaseWithParams<bool, RegisterUsecaseParams>{
  final IAuthRepository _authRepository;
  RegisterUsecase({required IAuthRepository authRepository})
  : _authRepository = authRepository;
  
  
  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity =  AuthEntity(
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      userName: params.userName,
      password: params.password,
    );
    return _authRepository.register(entity);
  }

}