import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medilink/core/services/analytics/analytics_service.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:medilink/features/auth/domain/usecases/login_usecase.dart';
import 'package:medilink/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:medilink/features/auth/domain/usecases/logout_usecase.dart';
import 'package:medilink/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:medilink/features/auth/domain/usecases/register_usecase.dart';
import 'package:medilink/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:medilink/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:medilink/features/auth/presentation/states/auth_state.dart';

// provider
final authViewModelProvider =
    NotifierProvider<AuthViewModel, AuthState>(() => AuthViewModel());

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final LogoutUsecase _logoutUsecase;
  late final ForgotPasswordUsecase _forgotPasswordUsecase;
  late final ResetPasswordUsecase _resetPasswordUsecase;
  late final VerifyEmailUsecase _verifyEmailUsecase;
  late final RefreshTokenUsecase _refreshTokenUsecase;
  late final LoginWithGoogleUsecase _loginWithGoogleUsecase;
  final AnalyticsService _analytics = AnalyticsService.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> _clearAuthTokens() async {
    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'refresh_token');
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refreshToken');
  }

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);
    _forgotPasswordUsecase = ref.read(forgotPasswordUsecaseProvider);
    _resetPasswordUsecase = ref.read(resetPasswordUsecaseProvider);
    _verifyEmailUsecase = ref.read(verifyEmailUsecaseProvider);
    _refreshTokenUsecase = ref.read(refreshTokenUsecaseProvider);
    _loginWithGoogleUsecase = ref.read(loginWithGoogleUsecaseProvider);
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
          _analytics.logSignUp(method: 'email');
        } else {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: 'Registration failed',
          );
        }
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = LoginUsecaseParams(email: email, password: password);
    final result = await _loginUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        );
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _logoutUsecase();

    // Always clear session state locally to prevent cross-account stale data.
    await ref.read(userSessionServiceProvider).clearSession();
    await _clearAuthTokens();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        errorMessage: null,
      ),
      (success) {
        _analytics.logLogout();
        _analytics.setUserId(null);
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
        );
      },
    );
  }

  Future<bool> forgotPassword({required String email}) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = ForgotPasswordParams(email: email);
    final result = await _forgotPasswordUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (success) {
        state = state.copyWith(status: AuthStatus.initial);
        return success;
      },
    );
  }

  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = ResetPasswordParams(
      token: token,
      newPassword: newPassword,
    );
    final result = await _resetPasswordUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (success) {
        state = state.copyWith(status: AuthStatus.initial);
        return success;
      },
    );
  }

  Future<bool> verifyEmail({required String token}) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = VerifyEmailParams(token: token);
    final result = await _verifyEmailUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (success) {
        state = state.copyWith(status: AuthStatus.initial);
        return success;
      },
    );
  }

  Future<String?> refreshToken({required String refreshToken}) async {
    final params = RefreshTokenParams(refreshToken: refreshToken);
    final result = await _refreshTokenUsecase(params);

    return result.fold(
      (failure) => null,
      (newToken) => newToken,
    );
  }

  Future<void> loginWithGoogle({required String idToken}) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = LoginWithGoogleParams(idToken: idToken);
    final result = await _loginWithGoogleUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        );
      },
    );
  }
}
