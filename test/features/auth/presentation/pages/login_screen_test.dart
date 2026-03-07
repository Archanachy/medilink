import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medilink/features/auth/presentation/pages/login_screen.dart';
import 'package:medilink/features/auth/presentation/states/auth_state.dart';
import 'package:medilink/features/auth/presentation/view_model/auth_view_model.dart';

class FakeAuthViewModel extends AuthViewModel {
  final AuthState _state;
  bool loginCalled = false;
  String? lastEmail;
  String? lastPassword;

  FakeAuthViewModel(this._state);

  @override
  AuthState build() => _state;

  @override
  Future<void> login({required String email, required String password}) async {
    loginCalled = true;
    lastEmail = email;
    lastPassword = password;
  }
}

void main() {
  Future<void> pumpLogin(WidgetTester tester, FakeAuthViewModel viewModel) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWith(() => viewModel),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets('calls login method when button tapped', (tester) async {
      // Arrange
      final fakeVm = FakeAuthViewModel(const AuthState(status: AuthStatus.initial));
      await pumpLogin(tester, fakeVm);

      // Act
      await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(fakeVm.loginCalled, isTrue);
      expect(fakeVm.lastEmail, 'user@example.com');
      expect(fakeVm.lastPassword, 'password123');
    });

    testWidgets('displays email and password fields', (tester) async {
      // Arrange
      final fakeVm = FakeAuthViewModel(const AuthState(status: AuthStatus.initial));
      await pumpLogin(tester, fakeVm);

      // Act & Assert
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });
  });
}