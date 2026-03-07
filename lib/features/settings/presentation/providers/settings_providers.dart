import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/settings/presentation/state/settings_state.dart';
import 'package:medilink/features/settings/presentation/viewmodel/settings_viewmodel.dart';

final settingsViewmodelProvider =
    NotifierProvider<SettingsViewmodel, SettingsState>(() {
  return SettingsViewmodel();
});
