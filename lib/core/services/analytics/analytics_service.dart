import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Analytics service wrapper for Firebase Analytics
/// 
/// Provides centralized analytics tracking with:
/// - Screen view tracking
/// - Event tracking
/// - User properties
/// - Custom parameters
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  static AnalyticsService get instance => _instance;

  late final FirebaseAnalytics _analytics;
  late final FirebaseAnalyticsObserver _observer;
  
  bool _isInitialized = false;

  /// Initialize Firebase Analytics
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _analytics = FirebaseAnalytics.instance;
      _observer = FirebaseAnalyticsObserver(analytics: _analytics);
      _isInitialized = true;

      // Set default user properties
      await setUserProperty('platform', defaultTargetPlatform.name);
      
      if (kDebugMode) {
        print('✅ Firebase Analytics initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️  Firebase Analytics initialization failed: $e');
      }
    }
  }

  /// Get the Firebase Analytics observer for route tracking
  FirebaseAnalyticsObserver get observer => _observer;

  /// Helper to filter out null values from parameters
  Map<String, Object>? _filterNullValues(Map<String, Object?>? parameters) {
    if (parameters == null) return null;
    return parameters.entries
        .where((entry) => entry.value != null)
        .fold<Map<String, Object>>({}, (map, entry) {
      map[entry.key] = entry.value!;
      return map;
    });
  }

  /// Log a screen view
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
    Map<String, Object?>? parameters,
  }) async {
    if (!_isInitialized) return;

    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
        parameters: _filterNullValues(parameters),
      );

      if (kDebugMode) {
        print('📊 Screen View: $screenName');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to log screen view: $e');
      }
    }
  }

  /// Log a custom event
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  }) async {
    if (!_isInitialized) return;

    try {
      await _analytics.logEvent(
        name: name,
        parameters: _filterNullValues(parameters),
      );

      if (kDebugMode) {
        print('📊 Event: $name ${parameters ?? ''}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to log event: $e');
      }
    }
  }

  /// Set user ID
  Future<void> setUserId(String? userId) async {
    if (!_isInitialized) return;

    try {
      await _analytics.setUserId(id: userId);

      if (kDebugMode) {
        print('📊 User ID set: $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to set user ID: $e');
      }
    }
  }

  /// Set user property
  Future<void> setUserProperty(String name, String? value) async {
    if (!_isInitialized) return;

    try {
      await _analytics.setUserProperty(name: name, value: value);

      if (kDebugMode) {
        print('📊 User Property: $name = $value');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to set user property: $e');
      }
    }
  }

  // ========== AUTHENTICATION EVENTS ==========

  Future<void> logLogin({String? method}) async {
    await logEvent(
      name: 'login',
      parameters: {'method': method ?? 'email'},
    );
  }

  Future<void> logSignUp({String? method}) async {
    await logEvent(
      name: 'sign_up',
      parameters: {'method': method ?? 'email'},
    );
  }

  Future<void> logLogout() async {
    await logEvent(name: 'logout');
  }

  // ========== APPOINTMENT EVENTS ==========

  Future<void> logAppointmentBooked({
    required String doctorId,
    required String doctorName,
    required String specialty,
    required String appointmentDate,
    required String appointmentType,
  }) async {
    await logEvent(
      name: 'appointment_booked',
      parameters: {
        'doctor_id': doctorId,
        'doctor_name': doctorName,
        'specialty': specialty,
        'appointment_date': appointmentDate,
        'appointment_type': appointmentType,
      },
    );
  }

  Future<void> logAppointmentCancelled({
    required String appointmentId,
    required String reason,
  }) async {
    await logEvent(
      name: 'appointment_cancelled',
      parameters: {
        'appointment_id': appointmentId,
        'reason': reason,
      },
    );
  }

  Future<void> logAppointmentRescheduled({
    required String appointmentId,
    required String newDate,
  }) async {
    await logEvent(
      name: 'appointment_rescheduled',
      parameters: {
        'appointment_id': appointmentId,
        'new_date': newDate,
      },
    );
  }

  // ========== VIDEO CONSULTATION EVENTS ==========

  Future<void> logVideoCallStarted({
    required String callId,
    required String doctorId,
  }) async {
    await logEvent(
      name: 'video_call_started',
      parameters: {
        'call_id': callId,
        'doctor_id': doctorId,
      },
    );
  }

  Future<void> logVideoCallEnded({
    required String callId,
    required int durationSeconds,
  }) async {
    await logEvent(
      name: 'video_call_ended',
      parameters: {
        'call_id': callId,
        'duration_seconds': durationSeconds,
      },
    );
  }

  // ========== PAYMENT EVENTS ==========

  Future<void> logPaymentInitiated({
    required String paymentId,
    required double amount,
    required String currency,
    required String paymentMethod,
  }) async {
    await logEvent(
      name: 'payment_initiated',
      parameters: {
        'payment_id': paymentId,
        'amount': amount,
        'currency': currency,
        'payment_method': paymentMethod,
      },
    );
  }

  Future<void> logPaymentCompleted({
    required String paymentId,
    required double amount,
    required String currency,
    required String paymentMethod,
  }) async {
    await logEvent(
      name: 'payment_completed',
      parameters: {
        'payment_id': paymentId,
        'amount': amount,
        'currency': currency,
        'payment_method': paymentMethod,
      },
    );
  }

  Future<void> logPaymentFailed({
    required String paymentId,
    required String errorMessage,
  }) async {
    await logEvent(
      name: 'payment_failed',
      parameters: {
        'payment_id': paymentId,
        'error_message': errorMessage,
      },
    );
  }

  // ========== PRESCRIPTION EVENTS ==========

  Future<void> logPrescriptionViewed({
    required String prescriptionId,
  }) async {
    await logEvent(
      name: 'prescription_viewed',
      parameters: {
        'prescription_id': prescriptionId,
      },
    );
  }

  Future<void> logPrescriptionDownloaded({
    required String prescriptionId,
  }) async {
    await logEvent(
      name: 'prescription_downloaded',
      parameters: {
        'prescription_id': prescriptionId,
      },
    );
  }

  // ========== HEALTH CONTENT EVENTS ==========

  Future<void> logArticleViewed({
    required String articleId,
    required String articleTitle,
    required String category,
  }) async {
    await logEvent(
      name: 'article_viewed',
      parameters: {
        'article_id': articleId,
        'article_title': articleTitle,
        'category': category,
      },
    );
  }

  Future<void> logHealthTipViewed({
    required String tipId,
    required String category,
  }) async {
    await logEvent(
      name: 'health_tip_viewed',
      parameters: {
        'tip_id': tipId,
        'category': category,
      },
    );
  }

  // ========== VITALS EVENTS ==========

  Future<void> logVitalRecorded({
    required String vitalType,
    required double value,
  }) async {
    await logEvent(
      name: 'vital_recorded',
      parameters: {
        'vital_type': vitalType,
        'value': value,
      },
    );
  }

  Future<void> logVitalsViewed({
    required String vitalType,
  }) async {
    await logEvent(
      name: 'vitals_viewed',
      parameters: {
        'vital_type': vitalType,
      },
    );
  }

  // ========== SEARCH EVENTS ==========

  Future<void> logSearch({
    required String query,
    required String searchType,
    int? resultCount,
  }) async {
    await logEvent(
      name: 'search',
      parameters: {
        'query': query,
        'search_type': searchType,
        if (resultCount != null) 'result_count': resultCount,
      },
    );
  }

  // ========== EMERGENCY EVENTS ==========

  Future<void> logEmergencyServiceContacted({
    required String serviceType,
  }) async {
    await logEvent(
      name: 'emergency_service_contacted',
      parameters: {
        'service_type': serviceType,
      },
    );
  }

  // ========== REVIEW EVENTS ==========

  Future<void> logReviewSubmitted({
    required String doctorId,
    required int rating,
  }) async {
    await logEvent(
      name: 'review_submitted',
      parameters: {
        'doctor_id': doctorId,
        'rating': rating,
      },
    );
  }

  // ========== HOSPITAL EVENTS ==========

  Future<void> logHospitalViewed({
    required String hospitalId,
    required String hospitalName,
  }) async {
    await logEvent(
      name: 'hospital_viewed',
      parameters: {
        'hospital_id': hospitalId,
        'hospital_name': hospitalName,
      },
    );
  }

  // ========== SETTINGS EVENTS ==========

  Future<void> logSettingChanged({
    required String settingName,
    required String newValue,
  }) async {
    await logEvent(
      name: 'setting_changed',
      parameters: {
        'setting_name': settingName,
        'new_value': newValue,
      },
    );
  }

  // ========== NOTIFICATION EVENTS ==========

  Future<void> logNotificationReceived({
    required String notificationType,
  }) async {
    await logEvent(
      name: 'notification_received',
      parameters: {
        'notification_type': notificationType,
      },
    );
  }

  Future<void> logNotificationOpened({
    required String notificationType,
    required String notificationId,
  }) async {
    await logEvent(
      name: 'notification_opened',
      parameters: {
        'notification_type': notificationType,
        'notification_id': notificationId,
      },
    );
  }

  // ========== ERROR TRACKING ==========

  Future<void> logError({
    required String errorType,
    required String errorMessage,
    String? screen,
  }) async {
    await logEvent(
      name: 'app_error',
      parameters: {
        'error_type': errorType,
        'error_message': errorMessage,
        if (screen != null) 'screen': screen,
      },
    );
  }
}
