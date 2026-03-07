
import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/auth/domain/enitities/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity user);
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, AuthEntity>> getCurrentUser();
  Future<Either<Failure, bool>> logout();
  
  // NEW METHODS
  Future<Either<Failure, bool>> forgotPassword(String email);
  Future<Either<Failure, bool>> resetPassword(String token, String newPassword);
  Future<Either<Failure, bool>> verifyEmail(String token);
  Future<Either<Failure, String>> refreshToken(String refreshToken);
  Future<Either<Failure, AuthEntity>> loginWithGoogle(String idToken);
  Future<Either<Failure, AuthEntity>> loginWithApple(String authorizationCode);
}