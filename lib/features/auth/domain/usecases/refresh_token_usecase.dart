import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/auth/data/repositories/auth_repository.dart';
import 'package:medilink/features/auth/domain/repositories/auth_repository.dart';

class RefreshTokenParams extends Equatable {
  final String refreshToken;
  const RefreshTokenParams({required this.refreshToken});
  
  @override
  List<Object?> get props => [refreshToken];
}

final refreshTokenUsecaseProvider = Provider<RefreshTokenUsecase>((ref) {
  return RefreshTokenUsecase(ref.read(authRepositoryProvider));
});

class RefreshTokenUsecase implements UsecaseWithParams<String, RefreshTokenParams> {
  final IAuthRepository _repository;
  
  RefreshTokenUsecase(this._repository);
  
  @override
  Future<Either<Failure, String>> call(RefreshTokenParams params) {
    return _repository.refreshToken(params.refreshToken);
  }
}
