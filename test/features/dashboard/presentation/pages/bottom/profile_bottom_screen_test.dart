import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medilink/features/dashboard/presentation/pages/bottom/profile_bottom_screen.dart';
import 'package:medilink/features/edit_profile/domain/enitities/user_profile_entity.dart';
import 'package:medilink/features/edit_profile/presentation/states/profile_state.dart';
import 'package:medilink/features/edit_profile/presentation/view_model/profile_view_model.dart';
import 'package:medilink/features/medical_records/presentation/states/medical_record_state.dart';
import 'package:medilink/features/medical_records/presentation/view_model/medical_record_view_model.dart';

class FakeProfileViewModel extends ProfileViewModel {
  final ProfileState _initial;
  FakeProfileViewModel(this._initial);

  @override
  ProfileState build() => _initial;

  @override
  Future<void> loadProfile() async {
    // no-op for tests
  }
}

class FakeMedicalRecordViewModel extends MedicalRecordViewModel {
  final MedicalRecordState _initial;
  FakeMedicalRecordViewModel(this._initial);

  @override
  MedicalRecordState build() => _initial;

  @override
  Future<void> fetchCurrentPatientRecords() async {
    // no-op for tests
  }
}

void main() {
  group('ProfileBottomScreen', () {
    testWidgets('shows loading indicator', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileViewModelProvider.overrideWith(
              () => FakeProfileViewModel(
                const ProfileState(status: ProfileStatus.loading),
              ),
            ),
            medicalRecordViewModelProvider.overrideWith(
              () => FakeMedicalRecordViewModel(
                const MedicalRecordState(status: MedicalRecordStatus.success),
              ),
            ),
          ],
          child: const MaterialApp(home: ProfileBottomScreen()),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error state with retry', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileViewModelProvider.overrideWith(
              () => FakeProfileViewModel(
                const ProfileState(
                  status: ProfileStatus.error,
                  errorMessage: 'Failed to load profile',
                ),
              ),
            ),
            medicalRecordViewModelProvider.overrideWith(
              () => FakeMedicalRecordViewModel(
                const MedicalRecordState(status: MedicalRecordStatus.success),
              ),
            ),
          ],
          child: const MaterialApp(home: ProfileBottomScreen()),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.text('Failed to load profile'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows loaded profile data', (tester) async {
      // Arrange
      const profile = UserProfileEntity(
        firstName: 'Pat',
        lastName: 'Smith',
        fullName: 'Pat Smith',
        email: 'pat@example.com',
        userName: 'patsmith',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileViewModelProvider.overrideWith(
              () => FakeProfileViewModel(
                const ProfileState(
                  status: ProfileStatus.loaded,
                  profile: profile,
                ),
              ),
            ),
            medicalRecordViewModelProvider.overrideWith(
              () => FakeMedicalRecordViewModel(
                const MedicalRecordState(status: MedicalRecordStatus.success),
              ),
            ),
          ],
          child: const MaterialApp(home: ProfileBottomScreen()),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.text('Pat Smith'), findsOneWidget);
      expect(find.text('@patsmith'), findsOneWidget);
      expect(find.text('pat@example.com'), findsWidgets);
    });
  });
}