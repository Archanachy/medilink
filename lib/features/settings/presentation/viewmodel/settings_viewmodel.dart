import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/settings/data/providers/settings_providers.dart';
import 'package:medilink/features/settings/domain/entities/settings_entity.dart';
import 'package:medilink/features/settings/presentation/state/settings_state.dart';

class SettingsViewmodel extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    // Auto-load settings on initialization
    Future.microtask(() => loadSettings());
    return const SettingsState();
  }

  Future<void> loadSettings() async {
    if (state.status == SettingsStatus.loading) return;

    state = state.copyWith(
      isLoading: true,
      status: SettingsStatus.loading,
    );

    final usecase = ref.read(getSettingsUsecaseProvider);
    final result = await usecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: SettingsStatus.error,
          error: failure.message,
        );
      },
      (settings) {
        state = state.copyWith(
          isLoading: false,
          status: SettingsStatus.loaded,
          settings: settings,
          error: null,
        );
      },
    );
  }

  Future<bool> updateSettings(SettingsEntity settings) async {
    state = state.copyWith(
      isLoading: true,
      status: SettingsStatus.updating,
    );

    final usecase = ref.read(updateSettingsUsecaseProvider);
    final result = await usecase(settings);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: SettingsStatus.error,
          error: failure.message,
        );
        return false;
      },
      (updatedSettings) {
        state = state.copyWith(
          isLoading: false,
          status: SettingsStatus.updated,
          settings: updatedSettings,
          error: null,
        );
        return true;
      },
    );
  }

  Future<void> toggleNotifications(bool enabled) async {
    if (state.settings == null) return;
    final settings = state.settings!.copyWith(notificationsEnabled: enabled);
    await updateSettings(settings);
  }

  Future<void> toggleEmailNotifications(bool enabled) async {
    if (state.settings == null) return;
    final settings = state.settings!.copyWith(emailNotifications: enabled);
    await updateSettings(settings);
  }

  Future<void> toggleSmsNotifications(bool enabled) async {
    if (state.settings == null) return;
    final settings = state.settings!.copyWith(smsNotifications: enabled);
    await updateSettings(settings);
  }

  Future<void> toggleAppointmentReminders(bool enabled) async {
    if (state.settings == null) return;
    final settings = state.settings!.copyWith(appointmentReminders: enabled);
    await updateSettings(settings);
  }

  Future<void> toggleMarketingEmails(bool enabled) async {
    if (state.settings == null) return;
    final settings = state.settings!.copyWith(marketingEmails: enabled);
    await updateSettings(settings);
  }

  Future<void> setTheme(String theme) async {
    if (state.settings == null) return;
    final settings = state.settings!.copyWith(theme: theme);
    await updateSettings(settings);
  }

  Future<void> toggleBiometric(bool enabled) async {
    if (state.settings == null) return;
    final settings = state.settings!.copyWith(biometricEnabled: enabled);
    await updateSettings(settings);
  }

  Future<void> toggleDataSharing(bool enabled) async {
    if (state.settings == null) return;
    final settings = state.settings!.copyWith(shareDataForResearch: enabled);
    await updateSettings(settings);
  }

  void clearError() {
    state = state.clearError();
  }
}
