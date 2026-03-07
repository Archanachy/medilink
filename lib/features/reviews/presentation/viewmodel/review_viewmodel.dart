import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/reviews/data/providers/review_providers.dart';
import 'package:medilink/features/reviews/domain/usecases/get_reviews_usecase.dart';
import 'package:medilink/features/reviews/domain/usecases/submit_review_usecase.dart';
import 'package:medilink/features/reviews/presentation/state/review_state.dart';

class ReviewViewmodel extends Notifier<ReviewState> {
  @override
  ReviewState build() {
    return const ReviewState();
  }

  Future<void> loadReviews({
    required String reviewableId,
    required String reviewableType,
  }) async {
    state = state.copyWith(
      isLoading: true,
      status: ReviewStatus.loading,
    );

    final usecase = ref.read(getReviewsUsecaseProvider);
    final params = GetReviewsParams(
      reviewableId: reviewableId,
      reviewableType: reviewableType,
    );

    final result = await usecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: ReviewStatus.error,
          error: failure.message,
        );
      },
      (reviews) {
        final averageRating = reviews.isEmpty
            ? 0.0
            : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
                reviews.length;

        state = state.copyWith(
          isLoading: false,
          status: ReviewStatus.loaded,
          reviews: reviews,
          averageRating: averageRating,
          totalReviews: reviews.length,
          error: null,
        );
      },
    );
  }

  Future<bool> submitReview({
    required String reviewableId,
    required String reviewableType,
    required double rating,
    required String comment,
    List<String>? tags,
  }) async {
    state = state.copyWith(
      isLoading: true,
      status: ReviewStatus.submitting,
    );

    final usecase = ref.read(submitReviewUsecaseProvider);
    final params = SubmitReviewParams(
      reviewableId: reviewableId,
      reviewableType: reviewableType,
      rating: rating,
      comment: comment,
      tags: tags,
    );

    final result = await usecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          status: ReviewStatus.error,
          error: failure.message,
        );
        return false;
      },
      (review) {
        state = state.copyWith(
          isLoading: false,
          status: ReviewStatus.submitted,
          reviews: [review, ...state.reviews],
          totalReviews: state.totalReviews + 1,
          error: null,
        );
        return true;
      },
    );
  }

  Future<void> markReviewHelpful(String reviewId) async {
    final usecase = ref.read(markReviewHelpfulUsecaseProvider);
    final result = await usecase(reviewId);

    result.fold(
      (failure) {
        // Optionally show error
      },
      (_) {
        // Update the review in the list
        final updatedReviews = state.reviews.map((review) {
          if (review.id == reviewId) {
            return review.copyWith(
              isHelpful: true,
              helpfulCount: review.helpfulCount + 1,
            );
          }
          return review;
        }).toList();

        state = state.copyWith(reviews: updatedReviews);
      },
    );
  }

  void clearError() {
    state = state.clearError();
  }
}
