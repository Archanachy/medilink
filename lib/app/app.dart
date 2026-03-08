import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/app/navigation/app_navigator.dart';
import 'package:medilink/app/theme/theme_mode_provider.dart';
import 'package:medilink/app/theme/theme_data.dart';
import 'package:medilink/core/widgets/shake_to_logout_wrapper.dart';
import 'package:medilink/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:medilink/features/auth/presentation/pages/login_screen.dart';
import 'package:medilink/features/auth/presentation/pages/reset_password_screen.dart';
import 'package:medilink/features/auth/presentation/pages/signup_screen.dart';
import 'package:medilink/features/appointments/presentation/pages/appointment_detail_screen.dart';
import 'package:medilink/features/appointments/presentation/pages/appointments_list_screen.dart';
import 'package:medilink/features/appointments/presentation/pages/book_appointment_screen.dart';
import 'package:medilink/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:medilink/features/chat/presentation/pages/chat_screen.dart';
import 'package:medilink/features/chat/presentation/pages/conversation_list_screen.dart';
import 'package:medilink/features/doctors/presentation/pages/doctor_detail_screen.dart';
import 'package:medilink/features/doctors/presentation/pages/doctors_list_screen.dart';
import 'package:medilink/features/medical_records/presentation/pages/record_detail_screen.dart';
import 'package:medilink/features/medical_records/presentation/pages/records_list_screen.dart';
import 'package:medilink/features/medical_records/presentation/pages/upload_record_screen.dart';
import 'package:medilink/features/notifications/presentation/pages/notification_screen.dart';
import 'package:medilink/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:medilink/features/splash/presentation/pages/splash_screen.dart';
import 'package:medilink/features/dashboard/presentation/pages/coming_soon_screen.dart';
import 'package:medilink/features/prescriptions/presentation/pages/prescriptions_list_screen.dart';
import 'package:medilink/features/prescriptions/presentation/pages/prescription_detail_screen.dart';
import 'package:medilink/features/prescriptions/presentation/pages/create_prescription_screen.dart';

class MediLinkApp extends ConsumerWidget {
  const MediLinkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(lightAutoModeProvider.select((state) => state.enabled));
    final appThemeMode = ref.watch(appThemeModeProvider);

    return ShakeToLogoutWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MediLink',
        navigatorKey: AppNavigator.key,

        // supply both themes
        theme: getLightTheme(),
        darkTheme: getDarkTheme(),

        themeMode: appThemeMode,

        initialRoute: '/',
        routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/doctors': (context) => const DoctorsListScreen(),
        '/appointments': (context) => const AppointmentsListScreen(),
        '/book-appointment': (context) => const BookAppointmentScreen(),
        '/records': (context) => const RecordsListScreen(),
        '/upload-record': (context) => const UploadRecordScreen(),
        '/notifications': (context) => const NotificationScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/conversations': (context) => const ConversationListScreen(),

        // Prescription routes
        '/prescriptions': (context) => const PrescriptionsListScreen(),
        '/create-prescription': (context) => const CreatePrescriptionScreen(),

        // New routes for unimplemented features
        '/health-tips': (context) => const ComingSoonScreen(
              featureName: 'Health Tips & Articles',
              estimatedDate: 'May 2026',
            ),
        '/vitals': (context) => const ComingSoonScreen(
              featureName: 'Health Vitals Tracking',
              estimatedDate: 'May 2026',
            ),
        '/my-reviews': (context) => const ComingSoonScreen(
              featureName: 'My Reviews',
              estimatedDate: 'April 2026',
            ),
        '/favorites': (context) => const ComingSoonScreen(
              featureName: 'Favorite Doctors',
              estimatedDate: 'May 2026',
            ),
        '/help-support': (context) => const ComingSoonScreen(
              featureName: 'Help & Support',
              estimatedDate: 'May 2026',
            ),
      },
      onGenerateRoute: (settings) {
        // Handle routes with parameters
        if (settings.name == '/reset-password') {
          final token = settings.arguments as String?;
          if (token != null) {
            return MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(token: token),
            );
          }
        }
        if (settings.name == '/doctor-detail') {
          final doctorId = settings.arguments as String?;
          if (doctorId != null) {
            return MaterialPageRoute(
              builder: (context) => DoctorDetailScreen(doctorId: doctorId),
            );
          }
        }
        if (settings.name == '/appointment-detail') {
          final appointmentId = settings.arguments as String?;
          if (appointmentId != null) {
            return MaterialPageRoute(
              builder: (context) => AppointmentDetailScreen(
                appointmentId: appointmentId,
              ),
            );
          }
        }
        if (settings.name == '/record-detail') {
          final recordId = settings.arguments as String?;
          if (recordId != null) {
            return MaterialPageRoute(
              builder: (context) => RecordDetailScreen(recordId: recordId),
            );
          }
        }
        if (settings.name == '/chat') {
          final args = settings.arguments as Map<String, dynamic>?;
          final receiverId = args?['receiverId'] as String?;
          final receiverName = args?['receiverName'] as String?;

          // If no specific receiver, show conversation list
          if (receiverId == null || receiverId.isEmpty) {
            return MaterialPageRoute(
              builder: (context) => const ConversationListScreen(),
            );
          }

          final userId = args?['userId'] as String? ?? 'demo-user';
          final conversationId =
              args?['conversationId'] as String? ?? 'demo-convo';
          return MaterialPageRoute(
            builder: (context) => ChatScreen(
              userId: userId,
              conversationId: conversationId,
              receiverId: receiverId,
              receiverName: receiverName,
            ),
          );
        }
        if (settings.name == '/prescription-detail') {
          final prescriptionId = settings.arguments as String?;
          if (prescriptionId != null) {
            return MaterialPageRoute(
              builder: (context) => PrescriptionDetailScreen(
                prescriptionId: prescriptionId,
              ),
            );
          }
        }

        return null;
      },
      ),
    );
  }
}
