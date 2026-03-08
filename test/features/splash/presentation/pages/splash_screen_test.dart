import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:medilink/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:medilink/features/splash/presentation/pages/splash_screen.dart';

class MockUserSessionService extends Mock implements UserSessionService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockUserSessionService mockSession;
  const secureStorageChannel =
      MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  String? mockedToken;

  setUp(() {
    mockSession = MockUserSessionService();
    mockedToken = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, (call) async {
      if (call.method == 'read') return mockedToken;
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, null);
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
      mockedToken = 'auth-token';

      // Act
      await pumpSplash(tester);
      // Splash animates ~3s before navigating; give enough time
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    testWidgets('navigates to Onboarding when not logged in', (tester) async {
      // Arrange
      when(() => mockSession.isLoggedIn()).thenReturn(false);
      mockedToken = null;

      // Act
      await pumpSplash(tester);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });
  });
}