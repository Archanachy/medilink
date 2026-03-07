import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/health_content/presentation/state/health_content_state.dart';
import 'package:medilink/features/health_content/presentation/viewmodel/health_content_viewmodel.dart';

final healthContentViewmodelProvider =
    NotifierProvider<HealthContentViewmodel, HealthContentState>(() {
  return HealthContentViewmodel();
});
