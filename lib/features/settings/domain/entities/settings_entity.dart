import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
  final String userId;
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool appointmentReminders;
  final bool marketingEmails;
  final String language;
  final String theme; // 'light', 'dark', 'system'
  final bool biometricEnabled;
  final bool shareDataForResearch;
  final DateTime updatedAt;

  const SettingsEntity({
    required this.userId,
    required this.notificationsEnabled,
    required this.emailNotifications,
    required this.smsNotifications,
    required this.appointmentReminders,
    required this.marketingEmails,
    required this.language,
    required this.theme,
    required this.biometricEnabled,
    required this.shareDataForResearch,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        userId,
        notificationsEnabled,
        emailNotifications,
        smsNotifications,
        appointmentReminders,
        marketingEmails,
        language,
        theme,
        biometricEnabled,
        shareDataForResearch,
        updatedAt,
      ];

  SettingsEntity copyWith({
    String? userId,
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? appointmentReminders,
    bool? marketingEmails,
    String? language,
    String? theme,
    bool? biometricEnabled,
    bool? shareDataForResearch,
    DateTime? updatedAt,
  }) {
    return SettingsEntity(
      userId: userId ?? this.userId,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      appointmentReminders: appointmentReminders ?? this.appointmentReminders,
      marketingEmails: marketingEmails ?? this.marketingEmails,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      shareDataForResearch: shareDataForResearch ?? this.shareDataForResearch,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
