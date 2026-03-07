/// Environment configuration for MediLink app
/// Manages different environment settings (dev, staging, prod)
class Environment {
  Environment._();

  /// Current environment type
  static EnvironmentType _currentEnvironment = EnvironmentType.development;

  /// Set the current environment
  static void setEnvironment(EnvironmentType env) {
    _currentEnvironment = env;
  }

  /// Get current environment
  static EnvironmentType get current => _currentEnvironment;

  /// Check if running in development
  static bool get isDevelopment => _currentEnvironment == EnvironmentType.development;

  /// Check if running in staging
  static bool get isStaging => _currentEnvironment == EnvironmentType.staging;

  /// Check if running in production
  static bool get isProduction => _currentEnvironment == EnvironmentType.production;

  /// Get base URL based on environment
  static String get baseUrl {
    switch (_currentEnvironment) {
      case EnvironmentType.development:
        // return 'http://10.0.2.2:5050'; // Android emulator
        return 'http://localhost:5050'; // Localhost
      case EnvironmentType.staging:
        return 'https://staging-api.medilink.com';
      case EnvironmentType.production:
        return 'https://api.medilink.com';
    }
  }

  /// Get WebSocket URL based on environment
  static String get wsUrl {
    switch (_currentEnvironment) {
      case EnvironmentType.development:
        // return 'ws://10.0.2.2:5050';
        return 'ws://localhost:5050';
      case EnvironmentType.staging:
        return 'wss://staging-api.medilink.com';
      case EnvironmentType.production:
        return 'wss://api.medilink.com';
    }
  }

  /// API timeout settings
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Pagination defaults
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  /// Cache settings
  static const Duration cacheValidity = Duration(hours: 24);
  static const int maxCacheSize = 50 * 1024 * 1024; // 50 MB

  /// File upload settings
  static const int maxFileSize = 10 * 1024 * 1024; // 10 MB
  static const int maxImageSize = 5 * 1024 * 1024; // 5 MB
  static const int maxVideoSize = 50 * 1024 * 1024; // 50 MB

  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocTypes = ['pdf', 'doc', 'docx'];
  static const List<String> allowedVideoTypes = ['mp4', 'mov', 'avi'];

  /// Background sync settings
  static const Duration syncInterval = Duration(hours: 1);
  static const Duration minSyncInterval = Duration(minutes: 15);

  /// Notification settings
  static const String fcmSenderId = 'YOUR_FCM_SENDER_ID';
  static const String apnsKeyId = 'YOUR_APNS_KEY_ID';

  /// Analytics & Monitoring
  static bool get enableAnalytics => !isDevelopment;
  static bool get enableCrashReporting => !isDevelopment;
  static bool get enablePerformanceMonitoring => isProduction;

  /// Debug settings
  static bool get enablePrettyDioLogger => isDevelopment;
  static bool get enableDevicePreview => isDevelopment;

  /// Feature flags
  static bool get enableChat => true;
  static bool get enableVideoCall => false; // Coming soon
  static bool get enablePayments => isProduction;
  static bool get enableEmergencyFeatures => true;

  /// Social login settings
  static String get googleClientId {
    if (isProduction) {
      return 'YOUR_PROD_GOOGLE_CLIENT_ID';
    }
    return 'YOUR_DEV_GOOGLE_CLIENT_ID';
  }

  static String get appleClientId {
    if (isProduction) {
      return 'YOUR_PROD_APPLE_CLIENT_ID';
    }
    return 'YOUR_DEV_APPLE_CLIENT_ID';
  }
}

/// Environment types
enum EnvironmentType {
  development,
  staging,
  production,
}

/// Environment configuration extensions
extension EnvironmentTypeExtension on EnvironmentType {
  String get name {
    switch (this) {
      case EnvironmentType.development:
        return 'Development';
      case EnvironmentType.staging:
        return 'Staging';
      case EnvironmentType.production:
        return 'Production';
    }
  }

  String get displayName {
    switch (this) {
      case EnvironmentType.development:
        return 'DEV';
      case EnvironmentType.staging:
        return 'STAGING';
      case EnvironmentType.production:
        return 'PROD';
    }
  }
}
