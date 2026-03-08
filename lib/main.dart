import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:medilink/app/app.dart';
import 'package:medilink/core/config/environment.dart';
import 'package:medilink/core/services/analytics/analytics_service.dart';
import 'package:medilink/core/services/hive/hive_service.dart';
import 'package:medilink/core/services/notifications/notification_service.dart';
import 'package:medilink/core/services/offline_queue/offline_queue_service.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Environment.setEnvironment(EnvironmentType.development);
  
  // Initialize Firebase with error handling
  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp();
    firebaseInitialized = true;
  } catch (e) {
    if (kDebugMode) {
      debugPrint('⚠️  Firebase initialization failed: $e');
      debugPrint('Continuing without Firebase services...');
    }
  }
  
  // Setup Crashlytics error handling (only if Firebase initialized)
  if (firebaseInitialized && Environment.isProduction) {
    FlutterError.onError = (FlutterErrorDetails details) {
      FirebaseCrashlytics.instance.recordFlutterError(details);
    };
    ui.PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } else {
    FlutterError.onError = (details) {
      FlutterError.dumpErrorToConsole(details);
    };
  }
  
  await HiveService().init();
  
  // Initialize offline queue service
  try {
    await OfflineQueueService().initialize();
  } catch (e) {
    if (kDebugMode) {
      debugPrint('⚠️  Offline queue initialization failed: $e');
    }
  }
  
  // Initialize analytics with error handling
  if (firebaseInitialized) {
    try {
      await AnalyticsService.instance.initialize();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️  Analytics service initialization failed: $e');
      }
    }
  }

  // Initialize notifications with error handling
  try {
    await NotificationService.instance.initialize();
  } catch (e) {
    if (kDebugMode) {
      debugPrint('⚠️  Notification service initialization failed: $e');
    }
  }

  final sharedprefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(overrides: [
    sharedPreferencesProvider.overrideWithValue(sharedprefs),
  ], child: const MediLinkApp()));
}
