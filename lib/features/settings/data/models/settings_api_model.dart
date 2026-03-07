import 'package:medilink/features/settings/domain/entities/settings_entity.dart';

class SettingsApiModel {
  final String userId;
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool appointmentReminders;
  final bool marketingEmails;
  final String language;
  final String theme;
  final bool biometricEnabled;
  final bool shareDataForResearch;
  final String updatedAt;

  SettingsApiModel({
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

  factory SettingsApiModel.fromJson(Map<String, dynamic> json) {
    return SettingsApiModel(
      userId: json['userId'] as String? ?? '',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      smsNotifications: json['smsNotifications'] as bool? ?? false,
      appointmentReminders: json['appointmentReminders'] as bool? ?? true,
      marketingEmails: json['marketingEmails'] as bool? ?? false,
      language: json['language'] as String? ?? 'en',
      theme: json['theme'] as String? ?? 'system',
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      shareDataForResearch: json['shareDataForResearch'] as bool? ?? false,
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'notificationsEnabled': notificationsEnabled,
      'emailNotifications': emailNotifications,
      'smsNotifications': smsNotifications,
      'appointmentReminders': appointmentReminders,
      'marketingEmails': marketingEmails,
      'language': language,
      'theme': theme,
      'biometricEnabled': biometricEnabled,
      'shareDataForResearch': shareDataForResearch,
      'updatedAt': updatedAt,
    };
  }

  SettingsEntity toEntity() {
    return SettingsEntity(
      userId: userId,
      notificationsEnabled: notificationsEnabled,
      emailNotifications: emailNotifications,
      smsNotifications: smsNotifications,
      appointmentReminders: appointmentReminders,
      marketingEmails: marketingEmails,
      language: language,
      theme: theme,
      biometricEnabled: biometricEnabled,
      shareDataForResearch: shareDataForResearch,
      updatedAt: DateTime.tryParse(updatedAt) ?? DateTime.now(),
    );
  }

  factory SettingsApiModel.fromEntity(SettingsEntity entity) {
    return SettingsApiModel(
      userId: entity.userId,
      notificationsEnabled: entity.notificationsEnabled,
      emailNotifications: entity.emailNotifications,
      smsNotifications: entity.smsNotifications,
      appointmentReminders: entity.appointmentReminders,
      marketingEmails: entity.marketingEmails,
      language: entity.language,
      theme: entity.theme,
      biometricEnabled: entity.biometricEnabled,
      shareDataForResearch: entity.shareDataForResearch,
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }
}
