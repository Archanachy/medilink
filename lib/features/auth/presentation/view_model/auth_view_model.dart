
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/auth/domain/usecases/login_usecase.dart';
import 'package:medilink/features/auth/domain/usecases/register_usecase.dart';
import 'package:medilink/features/auth/presentation/states/auth_state.dart';

// provider 
final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(() 
    => AuthViewModel());
class AuthViewModel extends Notifier<AuthState> {

  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  
  
  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    return const AuthState();
  }

  Future<void> register({
    required String fullName,
    required String email,
    String? phoneNumber,
    required String userName,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = RegisterUsecaseParams(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        userName: userName,
        password: password,
      
    );
    final result = await _registerUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (isRegistered) {
        if (isRegistered) {
          state = state.copyWith(status: AuthStatus.registered);
        } else {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: 'Registration failed',
          );
        }
      },
    );
  }
}