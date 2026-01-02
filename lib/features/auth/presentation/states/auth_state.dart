

import 'package:equatable/equatable.dart';
import 'package:medilink/features/auth/domain/enitities/auth_entity.dart';
enum AuthStatus { initial, authenticated, unauthenticated,registered, loading, error }
class AuthState extends Equatable{
  final AuthStatus status;
  final String? errorMessage;
  final AuthEntity? authEnitity;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.authEnitity,
  });

  // copywith 
  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    AuthEntity? authEnitity,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      authEnitity: authEnitity ?? this.authEnitity,
    );
  }
  @override
  List<Object?> get props => [status, errorMessage, authEnitity];
}