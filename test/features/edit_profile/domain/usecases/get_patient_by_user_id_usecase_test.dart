import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/edit_profile/domain/enitities/user_profile_entity.dart';
import 'package:medilink/features/edit_profile/domain/repositories/patient_repository.dart';
import 'package:medilink/features/edit_profile/domain/usecases/get_patient_by_user_id_usecase.dart';

class MockPatientRepository extends Mock implements IPatientRepository {}

void main() {
  late GetPatientByUserIdUsecase usecase;
  late MockPatientRepository mockRepository;

  setUp(() {
    mockRepository = MockPatientRepository();
    usecase = GetPatientByUserIdUsecase(mockRepository);
  });

  const tUserId = 'user-1';
  const tProfile = UserProfileEntity(
    userId: tUserId,
    patientId: 'patient-1',
    firstName: 'Pat',
    lastName: 'Smith',
    fullName: 'Pat Smith',
    email: 'pat@example.com',
    userName: 'patsmith',
  );

  group('GetPatientByUserIdUsecase', () {
    test('returns profile on success', () async {
      // Arrange
      when(() => mockRepository.getPatientByUserId(tUserId))
          .thenAnswer((_) async => const Right(tProfile));

      // Act
      final result = await usecase(tUserId);

      // Assert
      expect(result, const Right(tProfile));
      verify(() => mockRepository.getPatientByUserId(tUserId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('returns Failure on error', () async {
      // Arrange
      const failure = ApiFailure(message: 'Not found', statusCode: 404);
      when(() => mockRepository.getPatientByUserId(tUserId))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tUserId);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.getPatientByUserId(tUserId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}