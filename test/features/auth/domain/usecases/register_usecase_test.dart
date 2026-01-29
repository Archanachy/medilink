import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/auth/domain/enitities/auth_entity.dart';
import 'package:medilink/features/auth/domain/repositories/auth_repository.dart';
import 'package:medilink/features/auth/domain/usecases/register_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: mockRepository);
  });

  const params = RegisterUsecaseParams(
    fullName: 'Test User',
    email: 'test@example.com',
    phoneNumber: '1234567890',
    userName: 'testuser',
    password: 'password123',
  );

  final tUser = AuthEntity(
    fullName: params.fullName,
    email: params.email,
    phoneNumber: params.phoneNumber,
    userName: params.userName,
    password: params.password,
  );

  group('RegisterUsecase', () {
    test('returns true on success', () async {
      // Arrange
      when(() => mockRepository.register(tUser))
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(params);

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.register(tUser)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('returns Failure on error', () async {
      // Arrange
      const failure = ApiFailure(message: 'Email exists', statusCode: 409);
      when(() => mockRepository.register(tUser))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(params);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.register(tUser)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}