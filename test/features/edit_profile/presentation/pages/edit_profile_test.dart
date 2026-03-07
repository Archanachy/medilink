import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medilink/features/edit_profile/domain/enitities/user_profile_entity.dart';
import 'package:medilink/features/edit_profile/presentation/pages/edit_profile.dart';
import 'package:medilink/features/edit_profile/presentation/states/profile_state.dart';
import 'package:medilink/features/edit_profile/presentation/view_model/profile_view_model.dart';

class FakeProfileViewModel extends ProfileViewModel {
  final ProfileState _initial;
  FakeProfileViewModel(this._initial);

  bool updateCalled = false;

  @override
  ProfileState build() => _initial;

  @override
  Future<void> loadProfile() async {
    // no-op
  }

  @override
  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? dateOfBirth,
    String? bloodGroup,
    String? gender,
    String? address,
    String? emergencyContact,
    // Doctor-specific fields
    String? specialization,
    String? qualifications,
    int? experience,
    double? consultationFee,
    String? bio,
  }) async {
    updateCalled = true;
    state = const ProfileState(status: ProfileStatus.success);
  }
}

void main() {
  group('EditProfilePage', () {
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
          ],
          child: const MaterialApp(home: EditProfilePage()),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('populates fields when profile loaded and triggers update', (tester) async {
      // Arrange
      const profile = UserProfileEntity(
        firstName: 'Pat',
        lastName: 'Smith',
        fullName: 'Pat Smith',
        email: 'pat@example.com',
        userName: 'patsmith',
        phoneNumber: '1234567890',
      );

      final fakeVm = FakeProfileViewModel(
        const ProfileState(status: ProfileStatus.loaded, profile: profile),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileViewModelProvider.overrideWith(() => fakeVm),
          ],
          child: const MaterialApp(home: EditProfilePage()),
        ),
      );

      // Act
      await tester.pump();

      expect(find.widgetWithText(TextFormField, 'Pat'), findsOneWidget);

      await tester.enterText(find.widgetWithText(TextFormField, 'Pat'), 'Pat');
      await tester.enterText(find.widgetWithText(TextFormField, 'Smith'), 'Smith');
      
      // Scroll to bring Save Changes button into view
      await tester.ensureVisible(find.text('Save Changes'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      // Assert
      expect(fakeVm.updateCalled, isTrue);
    });
  });
}