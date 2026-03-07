import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/vitals/presentation/state/vitals_state.dart';
import 'package:medilink/features/vitals/presentation/viewmodel/vitals_viewmodel.dart';

final vitalsViewmodelProvider =
    NotifierProvider<VitalsViewmodel, VitalsState>(() {
  return VitalsViewmodel();
});
