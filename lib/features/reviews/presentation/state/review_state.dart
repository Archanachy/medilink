import 'package:medilink/features/reviews/domain/entities/review_entity.dart';

enum ReviewStatus {
  idle,
  loading,
  loaded,
  submitting,
  submitted,
  error,
}

class ReviewState {
  final ReviewStatus status;
  final List<ReviewEntity> reviews;
  final bool isLoading;
  final String? error;
  final double? averageRating;
  final int totalReviews;

  const ReviewState({
    this.status = ReviewStatus.idle,
    this.reviews = const [],
    this.isLoading = false,
    this.error,
    this.averageRating,
    this.totalReviews = 0,
  });

  ReviewState copyWith({
    ReviewStatus? status,
    List<ReviewEntity>? reviews,
    bool? isLoading,
    String? error,
    double? averageRating,
    int? totalReviews,
  }) {
    return ReviewState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }

  ReviewState clearError() {
    return copyWith(error: null);
  }
}
