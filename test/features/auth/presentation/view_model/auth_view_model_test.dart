import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/auth/domain/enitities/auth_entity.dart';
import 'package:medilink/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:medilink/features/auth/domain/usecases/login_usecase.dart';
import 'package:medilink/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:medilink/features/auth/domain/usecases/logout_usecase.dart';
import 'package:medilink/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:medilink/features/auth/domain/usecases/register_usecase.dart';
import 'package:medilink/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:medilink/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:medilink/features/auth/presentation/states/auth_state.dart';
import 'package:medilink/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:medilink/features/edit_profile/domain/enitities/user_profile_entity.dart';
import 'package:medilink/features/edit_profile/domain/usecases/get_patient_by_user_id_usecase.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockForgotPasswordUsecase extends Mock implements ForgotPasswordUsecase {}

class MockResetPasswordUsecase extends Mock implements ResetPasswordUsecase {}

class MockVerifyEmailUsecase extends Mock implements VerifyEmailUsecase {}

class MockRefreshTokenUsecase extends Mock implements RefreshTokenUsecase {}

class MockLoginWithGoogleUsecase extends Mock implements LoginWithGoogleUsecase {}

class MockGetPatientByUserIdUsecase extends Mock
    implements GetPatientByUserIdUsecase {}

class MockUserSessionService extends Mock implements UserSessionService {}

void main() {
  late MockLoginUsecase mockLoginUsecase;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockForgotPasswordUsecase mockForgotPasswordUsecase;
  late MockResetPasswordUsecase mockResetPasswordUsecase;
  late MockVerifyEmailUsecase mockVerifyEmailUsecase;
  late MockRefreshTokenUsecase mockRefreshTokenUsecase;
  late MockLoginWithGoogleUsecase mockLoginWithGoogleUsecase;
  late MockGetPatientByUserIdUsecase mockGetPatientByUserIdUsecase;
  late MockUserSessionService mockUserSessionService;
  late ProviderContainer container;
  late AuthViewModel viewModel;

  setUpAll(() {
    registerFallbackValue(
      const LoginUsecaseParams(email: 'email', password: 'password'),
    );
    registerFallbackValue(
      const RegisterUsecaseParams(
        fullName: 'name',
        email: 'email',
        phoneNumber: null,
        userName: 'user',
        password: 'password',
      ),
    );
  });

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    mockRegisterUsecase = MockRegisterUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockForgotPasswordUsecase = MockForgotPasswordUsecase();
    mockResetPasswordUsecase = MockResetPasswordUsecase();
    mockVerifyEmailUsecase = MockVerifyEmailUsecase();
    mockRefreshTokenUsecase = MockRefreshTokenUsecase();
    mockLoginWithGoogleUsecase = MockLoginWithGoogleUsecase();
    mockGetPatientByUserIdUsecase = MockGetPatientByUserIdUsecase();
    mockUserSessionService = MockUserSessionService();

    when(() => mockUserSessionService.getCurrentUserRole()).thenReturn(null);
    when(() => mockUserSessionService.getCurrentUserId()).thenReturn(null);

    container = ProviderContainer(
      overrides: [
        loginUsecaseProvider.overrideWith((ref) => mockLoginUsecase),
        registerUsecaseProvider.overrideWith((ref) => mockRegisterUsecase),
        logoutUsecaseProvider.overrideWith((ref) => mockLogoutUsecase),
      forgotPasswordUsecaseProvider
        .overrideWith((ref) => mockForgotPasswordUsecase),
      resetPasswordUsecaseProvider
        .overrideWith((ref) => mockResetPasswordUsecase),
      verifyEmailUsecaseProvider
        .overrideWith((ref) => mockVerifyEmailUsecase),
      refreshTokenUsecaseProvider
        .overrideWith((ref) => mockRefreshTokenUsecase),
      loginWithGoogleUsecaseProvider
        .overrideWith((ref) => mockLoginWithGoogleUsecase),
      getPatientByUserIdUsecaseProvider
        .overrideWith((ref) => mockGetPatientByUserIdUsecase),
      userSessionServiceProvider.overrideWith((ref) => mockUserSessionService),
      ],
    );
    addTearDown(container.dispose);

    viewModel = container.read(authViewModelProvider.notifier);
  });

  const tUser = AuthEntity(
    authId: '1',
    fullName: 'Test User',
    email: 'test@example.com',
    userName: 'testuser',
  );

  const tPatientProfile = UserProfileEntity(
    userId: 'user-1',
    patientId: 'patient-1',
    firstName: 'Pat',
    lastName: 'One',
    fullName: 'Pat One',
    email: 'pat@example.com',
    userName: 'patone',
  );

  group('login', () {
    test('emits authenticated state on success', () async {
      // Arrange
      when(() => mockLoginUsecase(any()))
          .thenAnswer((_) async => const Right(tUser));

      // Act
      await viewModel.login(email: 'test@example.com', password: 'password123');

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.user, tUser);
      expect(state.errorMessage, isNull);
      verify(() => mockLoginUsecase(
            const LoginUsecaseParams(
              email: 'test@example.com',
              password: 'password123',
            ),
          )).called(1);
      verifyNoMoreInteractions(mockLoginUsecase);
    });

    test('emits error state on failure', () async {
      // Arrange
      const failure = ApiFailure(message: 'Invalid credentials', statusCode: 401);
      when(() => mockLoginUsecase(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      await viewModel.login(email: 'test@example.com', password: 'wrong');

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.error);
      expect(state.user, isNull);
      expect(state.errorMessage, failure.message);
      verify(() => mockLoginUsecase(
            const LoginUsecaseParams(
              email: 'test@example.com',
              password: 'wrong',
            ),
          )).called(1);
      verifyNoMoreInteractions(mockLoginUsecase);
    });

      test('fetches and saves patientId when login succeeds for patient role', () async {
        when(() => mockLoginUsecase(any()))
          .thenAnswer((_) async => const Right(tUser));
        when(() => mockUserSessionService.getCurrentUserRole())
          .thenReturn('patient');
        when(() => mockUserSessionService.getCurrentUserId())
          .thenReturn('user-1');
        when(() => mockGetPatientByUserIdUsecase('user-1'))
          .thenAnswer((_) async => const Right(tPatientProfile));
        when(() => mockUserSessionService.savePatientId('patient-1'))
          .thenAnswer((_) async {});

        await viewModel.login(email: 'test@example.com', password: 'password123');

        verify(() => mockGetPatientByUserIdUsecase('user-1')).called(1);
        verify(() => mockUserSessionService.savePatientId('patient-1')).called(1);
      });

      test('does not fetch patient profile when role is doctor', () async {
        when(() => mockLoginUsecase(any()))
          .thenAnswer((_) async => const Right(tUser));
        when(() => mockUserSessionService.getCurrentUserRole())
          .thenReturn('doctor');

        await viewModel.login(email: 'test@example.com', password: 'password123');

        verifyNever(() => mockGetPatientByUserIdUsecase(any()));
        verifyNever(() => mockUserSessionService.savePatientId(any()));
      });

      test('does not fetch patient profile when patient role has null userId', () async {
        when(() => mockLoginUsecase(any()))
          .thenAnswer((_) async => const Right(tUser));
        when(() => mockUserSessionService.getCurrentUserRole())
          .thenReturn('patient');
        when(() => mockUserSessionService.getCurrentUserId()).thenReturn(null);

        await viewModel.login(email: 'test@example.com', password: 'password123');

        verifyNever(() => mockGetPatientByUserIdUsecase(any()));
        verifyNever(() => mockUserSessionService.savePatientId(any()));
      });

      test('does not save patientId when fetching profile fails', () async {
        const failure = ApiFailure(message: 'No patient profile', statusCode: 404);
        when(() => mockLoginUsecase(any()))
          .thenAnswer((_) async => const Right(tUser));
        when(() => mockUserSessionService.getCurrentUserRole())
          .thenReturn('patient');
        when(() => mockUserSessionService.getCurrentUserId())
          .thenReturn('user-1');
        when(() => mockGetPatientByUserIdUsecase('user-1'))
          .thenAnswer((_) async => const Left(failure));

        await viewModel.login(email: 'test@example.com', password: 'password123');

        verify(() => mockGetPatientByUserIdUsecase('user-1')).called(1);
        verifyNever(() => mockUserSessionService.savePatientId(any()));
      });
  });

  group('register', () {
    test('emits registered state on success', () async {
      // Arrange
      when(() => mockRegisterUsecase(any()))
          .thenAnswer((_) async => const Right(true));

      // Act
      await viewModel.register(
        fullName: 'Test User',
        email: 'test@example.com',
        phoneNumber: '1234567890',
        userName: 'testuser',
        password: 'password123',
      );

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.registered);
      expect(state.errorMessage, isNull);
      verify(() => mockRegisterUsecase(
            const RegisterUsecaseParams(
              fullName: 'Test User',
              email: 'test@example.com',
              phoneNumber: '1234567890',
              userName: 'testuser',
              password: 'password123',
            ),
          )).called(1);
      verifyNoMoreInteractions(mockRegisterUsecase);
    });

    test('emits error state on failure', () async {
      // Arrange
      const failure = ApiFailure(message: 'Email exists', statusCode: 409);
      when(() => mockRegisterUsecase(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      await viewModel.register(
        fullName: 'Test User',
        email: 'test@example.com',
        phoneNumber: null,
        userName: 'testuser',
        password: 'password123',
      );

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, failure.message);
      expect(state.user, isNull);
      verify(() => mockRegisterUsecase(
            const RegisterUsecaseParams(
              fullName: 'Test User',
              email: 'test@example.com',
              phoneNumber: null,
              userName: 'testuser',
              password: 'password123',
            ),
          )).called(1);
      verifyNoMoreInteractions(mockRegisterUsecase);
    });
  });
}