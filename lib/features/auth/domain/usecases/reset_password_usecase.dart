import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/auth/data/repositories/auth_repository.dart';
import 'package:medilink/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordParams extends Equatable {
  final String token;
  final String newPassword;
  
  const ResetPasswordParams({
    required this.token,
    required this.newPassword,
  });
  
  @override
  List<Object?> get props => [token, newPassword];
}

final resetPasswordUsecaseProvider = Provider<ResetPasswordUsecase>((ref) {
  return ResetPasswordUsecase(ref.read(authRepositoryProvider));
});

class ResetPasswordUsecase implements UsecaseWithParams<bool, ResetPasswordParams> {
  final IAuthRepository _repository;
  
  ResetPasswordUsecase(this._repository);
  
  @override
  Future<Either<Failure, bool>> call(ResetPasswordParams params) {
    return _repository.resetPassword(params.token, params.newPassword);
  }
}
