import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/auth/data/repositories/auth_repository.dart';
import 'package:medilink/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordParams extends Equatable {
  final String email;
  const ForgotPasswordParams({required this.email});
  
  @override
  List<Object?> get props => [email];
}

final forgotPasswordUsecaseProvider = Provider<ForgotPasswordUsecase>((ref) {
  return ForgotPasswordUsecase(ref.read(authRepositoryProvider));
});

class ForgotPasswordUsecase implements UsecaseWithParams<bool, ForgotPasswordParams> {
  final IAuthRepository _repository;
  
  ForgotPasswordUsecase(this._repository);
  
  @override
  Future<Either<Failure, bool>> call(ForgotPasswordParams params) {
    return _repository.forgotPassword(params.email);
  }
}
