import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medilink/features/auth/presentation/pages/signup_screen.dart';
import 'package:medilink/features/auth/presentation/states/auth_state.dart';
import 'package:medilink/features/auth/presentation/view_model/auth_view_model.dart';

class FakeAuthViewModel extends AuthViewModel {
  AuthState _state;
  bool registerCalled = false;
  String? lastFullName;
  String? lastEmail;
  String? lastUserName;
  String? lastPassword;

  FakeAuthViewModel(this._state);

  @override
  AuthState build() => _state;

  @override
  Future<void> register({
    required String fullName,
    required String email,
    String? phoneNumber,
    required String userName,
    required String password,
  }) async {
    registerCalled = true;
    lastFullName = fullName;
    lastEmail = email;
    lastUserName = userName;
    lastPassword = password;
  }
}

void main() {
  Future<void> pumpSignup(WidgetTester tester, FakeAuthViewModel viewModel) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWith(() => viewModel),
        ],
        child: const MaterialApp(home: SignupScreen()),
      ),
    );
  }

  group('SignupScreen', () {
    testWidgets('shows validation error when passwords mismatch', (tester) async {
      // Arrange
      final fakeVm = FakeAuthViewModel(const AuthState(status: AuthStatus.initial));
      await pumpSignup(tester, fakeVm);

      // Act
      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(2), 'password123');
      await tester.enterText(find.byType(TextField).at(3), 'different');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(find.text('Passwords do not match'), findsOneWidget);
      expect(fakeVm.registerCalled, isFalse);
    });

    testWidgets('calls register when passwords match', (tester) async {
      // Arrange
      final fakeVm = FakeAuthViewModel(const AuthState(status: AuthStatus.initial));
      await pumpSignup(tester, fakeVm);

      // Act
      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(2), 'password123');
      await tester.enterText(find.byType(TextField).at(3), 'password123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(fakeVm.registerCalled, isTrue);
      expect(fakeVm.lastFullName, 'Test User');
      expect(fakeVm.lastEmail, 'test@example.com');
      expect(fakeVm.lastPassword, 'password123');
    });

    testWidgets('displays all signup fields', (tester) async {
      // Arrange
      final fakeVm = FakeAuthViewModel(const AuthState(status: AuthStatus.initial));
      await pumpSignup(tester, fakeVm);

      // Act & Assert
      expect(find.byType(TextField), findsNWidgets(4));
      expect(find.text('Create Your Account'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}