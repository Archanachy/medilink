import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/availability/presentation/state/availability_state.dart';
import 'package:medilink/features/availability/presentation/viewmodel/availability_viewmodel.dart';

final availabilityViewmodelProvider =
    NotifierProvider<AvailabilityViewmodel, AvailabilityState>(() {
  return AvailabilityViewmodel();
});
