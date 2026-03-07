import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/reviews/presentation/state/review_state.dart';
import 'package:medilink/features/reviews/presentation/viewmodel/review_viewmodel.dart';

final reviewViewmodelProvider =
    NotifierProvider<ReviewViewmodel, ReviewState>(() {
  return ReviewViewmodel();
});
