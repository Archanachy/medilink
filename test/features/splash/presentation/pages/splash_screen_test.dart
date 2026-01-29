import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:medilink/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:medilink/features/splash/presentation/pages/splash_screen.dart';

class MockUserSessionService extends Mock implements UserSessionService {}

void main() {
  late MockUserSessionService mockSession;

  setUp(() {
    mockSession = MockUserSessionService();
  });

  Future<void> pumpSplash(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userSessionServiceProvider.overrideWith((ref) => mockSession),
        ],
        child: const MaterialApp(home: SplashScreen()),
      ),
    );
  }

  group('SplashScreen', () {
    testWidgets('navigates to Dashboard when logged in', (tester) async {
      // Arrange
      when(() => mockSession.isLoggedIn()).thenReturn(true);

      // Act
      await pumpSplash(tester);
      // Splash animates ~3s before navigating; give enough time
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    testWidgets('navigates to Onboarding when not logged in', (tester) async {
      // Arrange
      when(() => mockSession.isLoggedIn()).thenReturn(false);

      // Act
      await pumpSplash(tester);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });
  });
}