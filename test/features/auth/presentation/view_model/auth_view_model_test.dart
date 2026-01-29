import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/auth/domain/enitities/auth_entity.dart';
import 'package:medilink/features/auth/domain/usecases/login_usecase.dart';
import 'package:medilink/features/auth/domain/usecases/logout_usecase.dart';
import 'package:medilink/features/auth/domain/usecases/register_usecase.dart';
import 'package:medilink/features/auth/presentation/states/auth_state.dart';
import 'package:medilink/features/auth/presentation/view_model/auth_view_model.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late MockLoginUsecase mockLoginUsecase;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
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

    container = ProviderContainer(
      overrides: [
        loginUsecaseProvider.overrideWith((ref) => mockLoginUsecase),
        registerUsecaseProvider.overrideWith((ref) => mockRegisterUsecase),
        logoutUsecaseProvider.overrideWith((ref) => mockLogoutUsecase),
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