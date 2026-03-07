import 'package:medilink/features/settings/domain/entities/settings_entity.dart';

enum SettingsStatus {
  idle,
  loading,
  loaded,
  updating,
  updated,
  error,
}

class SettingsState {
  final SettingsStatus status;
  final SettingsEntity? settings;
  final bool isLoading;
  final String? error;

  const SettingsState({
    this.status = SettingsStatus.idle,
    this.settings,
    this.isLoading = false,
    this.error,
  });

  SettingsState copyWith({
    SettingsStatus? status,
    SettingsEntity? settings,
    bool? isLoading,
    String? error,
  }) {
    return SettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  SettingsState clearError() {
    return copyWith(error: null);
  }
}
