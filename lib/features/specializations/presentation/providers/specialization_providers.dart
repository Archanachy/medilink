import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/specializations/presentation/state/specialization_state.dart';
import 'package:medilink/features/specializations/presentation/viewmodel/specialization_viewmodel.dart';

final specializationViewmodelProvider =
    NotifierProvider<SpecializationViewmodel, SpecializationState>(() {
  return SpecializationViewmodel();
});
