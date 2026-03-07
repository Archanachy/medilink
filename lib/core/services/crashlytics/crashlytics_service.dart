import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:medilink/core/config/environment.dart';

/// Service for managing Firebase Crashlytics integration
class CrashlyticsService {
  static final CrashlyticsService _instance = CrashlyticsService._internal();

  factory CrashlyticsService() {
    return _instance;
  }

  CrashlyticsService._internal();

  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Initialize Crashlytics with proper settings
  Future<void> initialize() async {
    if (!Environment.isProduction) {
      // Disable collection in non-production to avoid false reports
      await _crashlytics.setCrashlyticsCollectionEnabled(false);
      return;
    }

    // Enable collection in production
    await _crashlytics.setCrashlyticsCollectionEnabled(true);

    // Set initial user-specific data
    _crashlytics.setUserIdentifier('user_id_here');
  }

  /// Record a Dart/Flutter exception
  Future<void> recordException(
    Object exception, {
    StackTrace? stack,
    bool fatal = false,
  }) async {
    if (!Environment.isProduction) {
      debugPrint('Exception: $exception\n$stack');
      return;
    }

    await _crashlytics.recordError(exception, stack, fatal: fatal);
  }

  /// Record a custom message
  Future<void> recordMessage(String message) async {
    if (!Environment.isProduction) {
      debugPrint('Message: $message');
      return;
    }

    _crashlytics.log(message);
  }

  /// Set user identifier for crash reporting
  Future<void> setUserIdentifier(String userId) async {
    try {
      await _crashlytics.setUserIdentifier(userId);
    } catch (e) {
      recordMessage('Failed to set user identifier: $e');
    }
  }

  /// Set custom key-value pair for crash context
  void setCustomKey(String key, dynamic value) {
    try {
      _crashlytics.setCustomKey(key, value is String ? value : value.toString());
    } catch (e) {
      recordMessage('Failed to set custom key $key: $e');
    }
  }

  /// Set multiple custom keys at once
  void setCustomKeys(Map<String, dynamic> keys) {
    keys.forEach((key, value) {
      setCustomKey(key, value);
    });
  }

  /// Check if Crashlytics collection is enabled
  bool get isEnabled => Environment.isProduction;

  /// Send any pending reports immediately (optional)
  Future<bool> checkForUnsentReports() async {
    try {
      return await _crashlytics.checkForUnsentReports();
    } catch (e) {
      recordMessage('Error checking for unsent reports: $e');
      return false;
    }
  }

  /// Clear all custom keys
  void clearCustomKeys() {
    // Crashlytics doesn't have a built-in method to clear all keys,
    // so we recommend using setCustomKey with empty values if needed
  }
}
