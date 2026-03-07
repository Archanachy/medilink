import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medilink/app/navigation/app_navigator.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    try {
      await _initializeLocalNotifications();
      await _requestPermissions();
      _setupMessageHandlers();
      await _handleInitialMessage();
    } catch (e) {
      debugPrint('⚠️  Failed to initialize notifications: $e');
      // Still initialize local notifications even if Firebase fails
      try {
        await _initializeLocalNotifications();
      } catch (e) {
        debugPrint('⚠️  Failed to initialize local notifications: $e');
      }
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(initSettings);
  }

  Future<void> _requestPermissions() async {
    try {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      debugPrint('⚠️  Failed to request notification permissions: $e');
    }
  }

  void _setupMessageHandlers() {
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (_handleVideoCallMessage(message)) {
          return;
        }
        _showLocalNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleDeepLink(message);
      });
    } catch (e) {
      debugPrint('⚠️  Failed to setup message handlers: $e');
    }
  }

  Future<void> _handleInitialMessage() async {
    try {
      final message = await _messaging.getInitialMessage();
      if (message != null) {
        _handleDeepLink(message);
      }
    } catch (e) {
      debugPrint('⚠️  Failed to read initial message: $e');
    }
  }

  bool _handleVideoCallMessage(RemoteMessage message) {
    final type = message.data['type']?.toString();
    if (type != 'video_call') {
      return false;
    }

    _navigateToIncomingCall(message.data);
    return true;
  }

  void _handleDeepLink(RemoteMessage message) {
    final type = message.data['type']?.toString();
    if (type == 'video_call') {
      _navigateToIncomingCall(message.data);
      return;
    }

    _showLocalNotification(message);
  }

  void _navigateToIncomingCall(Map<String, dynamic> data) {
    final navigator = AppNavigator.key.currentState;
    if (navigator == null) {
      return;
    }

    final callId = data['callId']?.toString();
    final appointmentId = data['appointmentId']?.toString();
    final doctorId = data['doctorId']?.toString();
    final patientId = data['patientId']?.toString();
    final callerName = data['callerName']?.toString();

    if (callId == null ||
        appointmentId == null ||
        doctorId == null ||
        patientId == null) {
      return;
    }

    navigator.pushNamed(
      '/incoming-call',
      arguments: {
        'callId': callId,
        'appointmentId': appointmentId,
        'doctorId': doctorId,
        'patientId': patientId,
        'callerName': callerName,
      },
    );
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'medilink_notifications',
      'MediLink Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final title = message.notification?.title ?? 'MediLink';
    final body = message.notification?.body ?? 'You have a new notification';

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }
}
