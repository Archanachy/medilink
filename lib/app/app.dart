import 'package:flutter/material.dart';
import 'package:medilink/app/theme/theme_data.dart';
import 'package:medilink/features/auth/presentation/pages/login_screen.dart';
import 'package:medilink/features/auth/presentation/pages/signup_screen.dart';
import 'package:medilink/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:medilink/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:medilink/features/splash/presentation/pages/splash_screen.dart';

class MediLinkApp extends StatelessWidget {
  const MediLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediLink',

      // supply both themes
      theme: getLightTheme(),
      darkTheme: getDarkTheme(),

      // Choose theme behavior:
      // - ThemeMode.system: follow device setting (recommended)
      // - ThemeMode.light: force light
      // - ThemeMode.dark: force dark
      themeMode: ThemeMode.system,

      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
