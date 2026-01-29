import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/edit_profile/domain/enitities/user_profile_entity.dart';
import 'package:medilink/features/edit_profile/domain/usecases/get_patient_by_user_id_usecase.dart';
import 'package:medilink/features/edit_profile/domain/usecases/update_patient_usecase.dart';
import 'package:medilink/features/edit_profile/presentation/states/profile_state.dart';
import 'package:medilink/features/edit_profile/presentation/view_model/profile_view_model.dart';

class MockGetPatientByUserIdUsecase extends Mock
    implements GetPatientByUserIdUsecase {}

class MockUpdatePatientUsecase extends Mock implements UpdatePatientUsecase {}

class MockUserSessionService extends Mock implements UserSessionService {}

void main() {
  late MockGetPatientByUserIdUsecase mockGetPatientByUserIdUsecase;
  late MockUpdatePatientUsecase mockUpdatePatientUsecase;
  late MockUserSessionService mockUserSessionService;
  late ProviderContainer container;
  late ProfileViewModel viewModel;

  setUpAll(() {
    registerFallbackValue(
      UpdatePatientParams(
        patientId: 'fallback',
        patient: const UserProfileEntity(
          userId: 'user',
          patientId: 'patient',
          firstName: 'first',
          lastName: 'last',
          fullName: 'first last',
          email: 'email',
          userName: 'user',
        ),
        profileImage: null,
      ),
    );
  });

  setUp(() {
    mockGetPatientByUserIdUsecase = MockGetPatientByUserIdUsecase();
    mockUpdatePatientUsecase = MockUpdatePatientUsecase();
    mockUserSessionService = MockUserSessionService();

    container = ProviderContainer(
      overrides: [
        getPatientByUserIdUsecaseProvider
            .overrideWith((ref) => mockGetPatientByUserIdUsecase),
        updatePatientUsecaseProvider.overrideWith((ref) => mockUpdatePatientUsecase),
        userSessionServiceProvider.overrideWith((ref) => mockUserSessionService),
      ],
    );
    addTearDown(container.dispose);

    viewModel = container.read(profileViewModelProvider.notifier);
  });

  const tUserId = 'user-1';
  const tPatientId = 'patient-1';
  const tProfile = UserProfileEntity(
    userId: tUserId,
    patientId: tPatientId,
    firstName: 'Pat',
    lastName: 'Smith',
    fullName: 'Pat Smith',
    email: 'pat@example.com',
    userName: 'patsmith',
  );

  group('loadProfile', () {
    test('loads profile when no cached patient id', () async {
      // Arrange
      const sessionEmail = 'session@example.com';
      const sessionUsername = 'sessionUser';

      when(() => mockUserSessionService.getCurrentPatientId()).thenReturn(null);
      when(() => mockUserSessionService.getCurrentUserId()).thenReturn(tUserId);
      when(() => mockUserSessionService.getCurrentUserEmail()).thenReturn(sessionEmail);
      when(() => mockUserSessionService.getCurrentUserUsername())
          .thenReturn(sessionUsername);
      when(() => mockUserSessionService.savePatientId(any()))
          .thenAnswer((_) async {});
      when(() => mockGetPatientByUserIdUsecase(tUserId))
          .thenAnswer((_) async => const Right(tProfile));

      // Act
      await viewModel.loadProfile();

      // Assert
      final state = container.read(profileViewModelProvider);
      final expectedProfile = tProfile.copyWith(
        email: sessionEmail,
        userName: sessionUsername,
      );
      expect(state.status, ProfileStatus.loaded);
      expect(state.profile, expectedProfile);
      expect(state.errorMessage, isNull);
      verify(() => mockGetPatientByUserIdUsecase(tUserId)).called(1);
      verify(() => mockUserSessionService.savePatientId(tPatientId)).called(1);
      verifyNoMoreInteractions(mockGetPatientByUserIdUsecase);
    });

    test('sets error when user id missing', () async {
      // Arrange
      when(() => mockUserSessionService.getCurrentPatientId()).thenReturn(null);
      when(() => mockUserSessionService.getCurrentUserId()).thenReturn(null);

      // Act
      await viewModel.loadProfile();

      // Assert
      final state = container.read(profileViewModelProvider);
      expect(state.status, ProfileStatus.error);
      expect(state.errorMessage, 'User not found in session');
      verifyNever(() => mockGetPatientByUserIdUsecase(any()));
    });

    test('sets error when fetch fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Not found', statusCode: 404);
      when(() => mockUserSessionService.getCurrentPatientId()).thenReturn(null);
      when(() => mockUserSessionService.getCurrentUserId()).thenReturn(tUserId);
      when(() => mockGetPatientByUserIdUsecase(tUserId))
          .thenAnswer((_) async => const Left(failure));

      // Act
      await viewModel.loadProfile();

      // Assert
      final state = container.read(profileViewModelProvider);
      expect(state.status, ProfileStatus.error);
      expect(state.errorMessage, failure.message);
      verify(() => mockGetPatientByUserIdUsecase(tUserId)).called(1);
      verifyNoMoreInteractions(mockGetPatientByUserIdUsecase);
    });
  });

  group('updateProfile', () {
    test('updates profile successfully', () async {
      // Arrange
      when(() => mockUserSessionService.getCurrentPatientId())
          .thenReturn(tPatientId);
      when(() => mockUserSessionService.getCurrentUserId())
          .thenReturn(tUserId);
      when(() => mockUserSessionService.getCurrentUserEmail())
          .thenReturn('session@example.com');
      when(() => mockUserSessionService.getCurrentUserUsername())
          .thenReturn('sessionUser');
      when(() => mockUpdatePatientUsecase(any()))
          .thenAnswer((_) async => const Right(tProfile));

      // Act
      await viewModel.loadProfile();
      await viewModel.updateProfile(
        firstName: 'Pat',
        lastName: 'Smith',
        phoneNumber: '1234567890',
        dateOfBirth: '2000-01-01',
        bloodGroup: 'A+',
        gender: 'M',
        address: '123 Street',
      );

      // Assert
      final state = container.read(profileViewModelProvider);
      expect(state.status, ProfileStatus.success);
      expect(state.profile, tProfile);
      expect(state.successMessage, 'Profile updated successfully');
      final captured = verify(() => mockUpdatePatientUsecase(captureAny()))
          .captured
          .single as UpdatePatientParams;
      expect(captured.patientId, tPatientId);
      expect(captured.patient.firstName, 'Pat');
      expect(captured.patient.lastName, 'Smith');
      expect(captured.patient.fullName, 'Pat Smith');
      expect(captured.patient.email, 'session@example.com');
      expect(captured.patient.userName, 'sessionUser');
      expect(captured.patient.phoneNumber, '1234567890');
      expect(captured.patient.dateOfBirth, '2000-01-01');
      expect(captured.patient.bloodGroup, 'A+');
      expect(captured.patient.gender, 'M');
      expect(captured.patient.address, '123 Street');
    });

    test('sets error when update fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Update failed', statusCode: 500);
      when(() => mockUserSessionService.getCurrentPatientId())
          .thenReturn(tPatientId);
      when(() => mockUserSessionService.getCurrentUserId())
          .thenReturn(tUserId);
      when(() => mockUserSessionService.getCurrentUserEmail())
          .thenReturn('session@example.com');
      when(() => mockUserSessionService.getCurrentUserUsername())
          .thenReturn('sessionUser');
      when(() => mockUpdatePatientUsecase(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      await viewModel.loadProfile();
      await viewModel.updateProfile(
        firstName: 'Pat',
        lastName: 'Smith',
        phoneNumber: null,
        dateOfBirth: null,
        bloodGroup: null,
        gender: null,
        address: null,
      );

      // Assert
      final state = container.read(profileViewModelProvider);
      expect(state.status, ProfileStatus.error);
      expect(state.errorMessage, failure.message);
      verify(() => mockUpdatePatientUsecase(any())).called(1);
    });

    test('sets error when patient id missing', () async {
      // Arrange
      when(() => mockUserSessionService.getCurrentPatientId())
          .thenReturn(null);

      // Act
      await viewModel.updateProfile(
        firstName: 'Pat',
        lastName: 'Smith',
        phoneNumber: null,
        dateOfBirth: null,
        bloodGroup: null,
        gender: null,
        address: null,
      );

      // Assert
      final state = container.read(profileViewModelProvider);
      expect(state.status, ProfileStatus.error);
      expect(state.errorMessage, 'Patient record not loaded');
      verifyNever(() => mockUpdatePatientUsecase(any()));
    });
  });
}