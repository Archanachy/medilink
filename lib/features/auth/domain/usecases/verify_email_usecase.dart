import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/auth/data/repositories/auth_repository.dart';
import 'package:medilink/features/auth/domain/repositories/auth_repository.dart';

class VerifyEmailParams extends Equatable {
  final String token;
  const VerifyEmailParams({required this.token});
  
  @override
  List<Object?> get props => [token];
}

final verifyEmailUsecaseProvider = Provider<VerifyEmailUsecase>((ref) {
  return VerifyEmailUsecase(ref.read(authRepositoryProvider));
});

class VerifyEmailUsecase implements UsecaseWithParams<bool, VerifyEmailParams> {
  final IAuthRepository _repository;
  
  VerifyEmailUsecase(this._repository);
  
  @override
  Future<Either<Failure, bool>> call(VerifyEmailParams params) {
    return _repository.verifyEmail(params.token);
  }
}
