import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/features/reviews/data/datasources/review_remote_data_source.dart';
import 'package:medilink/features/reviews/data/repositories/review_repository_impl.dart';
import 'package:medilink/features/reviews/domain/repositories/i_review_repository.dart';
import 'package:medilink/features/reviews/domain/usecases/get_reviews_usecase.dart';
import 'package:medilink/features/reviews/domain/usecases/mark_review_helpful_usecase.dart';
import 'package:medilink/features/reviews/domain/usecases/submit_review_usecase.dart';

// Data source
final reviewRemoteDataSourceProvider = Provider<ReviewRemoteDataSource>((ref) {
  return ReviewRemoteDataSource(ref.watch(apiClientProvider));
});

// Repository
final reviewRepositoryProvider = Provider<IReviewRepository>((ref) {
  return ReviewRepositoryImpl(ref.watch(reviewRemoteDataSourceProvider));
});

// Use cases
final getReviewsUsecaseProvider = Provider<GetReviewsUsecase>((ref) {
  return GetReviewsUsecase(ref.watch(reviewRepositoryProvider));
});

final submitReviewUsecaseProvider = Provider<SubmitReviewUsecase>((ref) {
  return SubmitReviewUsecase(ref.watch(reviewRepositoryProvider));
});

final markReviewHelpfulUsecaseProvider = Provider<MarkReviewHelpfulUsecase>((ref) {
  return MarkReviewHelpfulUsecase(ref.watch(reviewRepositoryProvider));
});
