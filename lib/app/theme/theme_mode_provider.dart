import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light/light.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';

const String _themeModeKey = 'app_theme_mode';
const String _lightAutoModeEnabledKey = 'light_auto_mode_enabled';

final appThemeModeProvider = NotifierProvider<AppThemeModeNotifier, ThemeMode>(
  AppThemeModeNotifier.new,
);

final lightAutoModeProvider =
    NotifierProvider<LightAutoModeNotifier, LightAutoModeState>(
  LightAutoModeNotifier.new,
);

class LightAutoModeState {
  final bool enabled;
  final double? currentLux;

  const LightAutoModeState({
    required this.enabled,
    required this.currentLux,
  });

  LightAutoModeState copyWith({
    bool? enabled,
    double? currentLux,
    bool clearLux = false,
  }) {
    return LightAutoModeState(
      enabled: enabled ?? this.enabled,
      currentLux: clearLux ? null : (currentLux ?? this.currentLux),
    );
  }
}

class AppThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final savedValue = prefs.getString(_themeModeKey);

    switch (savedValue) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setDarkMode(bool enabled) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final nextMode = enabled ? ThemeMode.dark : ThemeMode.light;

    state = nextMode;
    await prefs.setString(_themeModeKey, enabled ? 'dark' : 'light');
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);

    state = mode;
    switch (mode) {
      case ThemeMode.light:
        await prefs.setString(_themeModeKey, 'light');
        break;
      case ThemeMode.dark:
        await prefs.setString(_themeModeKey, 'dark');
        break;
      case ThemeMode.system:
        await prefs.setString(_themeModeKey, 'system');
        break;
    }
  }
}

class LightAutoModeNotifier extends Notifier<LightAutoModeState> {
  final Light _light = Light();
  StreamSubscription<int>? _lightSubscription;

  @override
  LightAutoModeState build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final enabled = prefs.getBool(_lightAutoModeEnabledKey) ?? false;

    ref.onDispose(() {
      _lightSubscription?.cancel();
    });

    if (enabled) {
      _startSensor();
    }

    return LightAutoModeState(enabled: enabled, currentLux: null);
  }

  Future<void> setEnabled(bool enabled) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_lightAutoModeEnabledKey, enabled);

    if (enabled) {
      state = state.copyWith(enabled: true);
      await _startSensor();
      return;
    }

    await _stopSensor();
    state = state.copyWith(enabled: false, clearLux: true);
  }

  Future<void> _startSensor() async {
    await _lightSubscription?.cancel();

    try {
      _lightSubscription = _light.lightSensorStream.listen(
        (lux) {
          state = state.copyWith(currentLux: lux.toDouble(), enabled: true);
          _applyThemeFromLux(lux);
        },
        onError: (_) async {
          await _stopSensor();
          final prefs = ref.read(sharedPreferencesProvider);
          await prefs.setBool(_lightAutoModeEnabledKey, false);
          state = state.copyWith(enabled: false, clearLux: true);
        },
      );
    } catch (_) {
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setBool(_lightAutoModeEnabledKey, false);
      state = state.copyWith(enabled: false, clearLux: true);
    }
  }

  Future<void> _stopSensor() async {
    await _lightSubscription?.cancel();
    _lightSubscription = null;
  }

  void _applyThemeFromLux(int lux) {
    final shouldBeDark = lux < 20;
    final currentMode = ref.read(appThemeModeProvider);
    final isCurrentlyDark = currentMode == ThemeMode.dark;

    if (shouldBeDark && !isCurrentlyDark) {
      ref.read(appThemeModeProvider.notifier).setDarkMode(true);
    } else if (!shouldBeDark && isCurrentlyDark) {
      ref.read(appThemeModeProvider.notifier).setDarkMode(false);
    }
  }
}
