import 'package:medilink/core/config/environment.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // ============ Base URLs ============
  static String get baseUrl => Environment.baseUrl;
  static String get authBase => '${Environment.baseUrl}/auth';
  static String get apiBase => '${Environment.baseUrl}/api/v1';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Authentication Endpoints ============
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String refreshToken = '/auth/refresh-token';
  static const String me = '/auth/me';
  static const String googleAuth = '/auth/google';
  static const String appleAuth = '/auth/apple';

  // ============ User Endpoints ============
  static const String users = '/api/auth/users';
  static String userById(String id) => '/api/auth/users/$id';
  static String userPhoto(String id) => '/api/auth/users/$id/photo';
  static String userAppointments(String id) =>
      '/api/auth/users/$id/appointments';
  static String userRecords(String id) => '/api/auth/users/$id/records';
  static String userSettings(String id) => '/api/auth/users/$id/settings';

  // ============ Patient Endpoints ============
  static const String patients = '/auth/patients';
  static String patientById(String id) => '/auth/patients/$id';
  static String patientByUserId(String userId) => '/auth/patients/user/$userId';
  static String patientHistory(String id) => '/auth/patients/$id/history';
  static String patientRecords(String id) => '/auth/patients/$id/records';
  static String patientVitals(String id) => '/auth/patients/$id/vitals';

  // ============ Doctor Endpoints ============
  static const String doctors = '/auth/doctors';
  static String doctorById(String id) => '/auth/doctors/$id';
  static String doctorAvailability(String id) =>
      '/auth/doctors/$id/availability';
  static String doctorReviews(String id) => '/auth/doctors/$id/reviews';
  static String doctorsBySpecialization(String spec) =>
      '/auth/doctors/specialization/$spec';
  static String doctorSchedule(String id) => '/auth/doctors/$id/schedule';

  // ============ Specialization Endpoints ============
  static const String specializations = '/auth/specializations';
  static String specializationById(String id) => '/auth/specializations/$id';

  // ============ Appointment Endpoints ============
  static const String appointments = '/auth/appointments';
  static String appointmentById(String id) => '/auth/appointments/$id';
  static String appointmentsByUser(String userId) =>
      '/auth/appointments/patient/$userId';
  static String appointmentsByDoctor(String docId) =>
      '/auth/appointments/doctor/$docId';
  static String appointmentStatus(String id) => '/auth/appointments/$id/status';
  static const String upcomingAppointments = '/auth/appointments/upcoming';
  static const String pastAppointments = '/auth/appointments/past';
  static const String appointmentHistory = '/auth/appointments/history';
  static String cancelAppointment(String id) => '/auth/appointments/$id/cancel';
  static String rescheduleAppointment(String id) =>
      '/auth/appointments/$id/reschedule';
  static const String availableSlots = '/auth/appointments/available-slots';

  // ============ Medical Records Endpoints ============
  static const String records = '/patient/reports';
  static String recordById(String id) => '/patient/reports/$id';
  static String recordsByPatient(String patientId) =>
      '/patient/reports?patientId=$patientId';
  static String recordFiles(String id) => '/patient/reports/$id';
  static String recordDownload(String id) => '/patient/reports/$id';
  static String recordShare(String id) => '/patient/reports/$id/share';

  // ============ Prescription Endpoints ============
  static const String prescriptions = '/prescriptions';
  static const String doctorPrescriptions = '/doctor/prescriptions';
  static const String patientPrescriptions = '/patient/prescriptions';
  static String prescriptionById(String id) => '/prescriptions/$id';
  static String prescriptionsByPatient(String patientId) =>
      '/prescriptions/patient/$patientId';

  // ============ Notification Endpoints ============
  static const String notifications = '/notifications';
  static String notificationById(String id) => '/notifications/$id';
  static String notificationRead(String id) => '/notifications/$id/read';
  static const String notificationSettings = '/notifications/settings';
  static const String markAllRead = '/notifications/read-all';

  // ============ Chat/Messaging Endpoints ============
  static const String conversations = '/messages/conversations';
  static String conversationById(String id) => '/messages/conversations/$id';
  static const String createConversation = '/messages/conversations/create';
  static String conversationMessages(String id) => '/messages/$id';
  static const String sendMessage = '/messages';
  static const String chatWebSocket = '/ws/chat';
  static String markMessageRead(String messageId) =>
      '/messages/$messageId/read';
  static String markChatRoomRead(String chatRoomId) =>
      '/messages/conversations/$chatRoomId/read';

  // ============ Search Endpoints ============
  static const String searchDoctors = '/search/doctors';
  static const String searchSpecializations = '/search/specializations';
  static const String searchLocations = '/search/locations';

  // ============ Review/Rating Endpoints ============
  static const String reviews = '/reviews';
  static String reviewsByDoctor(String doctorId) => '/reviews/doctor/$doctorId';

  // ============ Health Tips & Articles ============
  static const String healthTips = '/health-tips';
  static String healthTipById(String id) => '/health-tips/$id';
  static const String healthTipsCategories = '/health-tips/categories';
  static const String articles = '/articles';
  static String articleById(String id) => '/articles/$id';

  // ============ Payment Endpoints ============
  static const String payments = '/payments';
  static String paymentById(String id) => '/payments/$id';
  static const String processPayment = '/payments/process';
  static String paymentHistory(String userId) => '/payments/user/$userId';

  // ============ Video Consultation Endpoints ============
  static const String videoCalls = '/video-calls';
  static String videoCallById(String id) => '/video-calls/$id';
  static const String startVideoCall = '/video-calls/start';
  static const String joinVideoCall = '/video-calls/join';
  static String endVideoCall(String id) => '/video-calls/$id/end';
  static String videoCallHistory(String userId) => '/video-calls/user/$userId';
}
