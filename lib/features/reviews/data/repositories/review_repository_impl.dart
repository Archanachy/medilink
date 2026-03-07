import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/reviews/data/datasources/review_remote_data_source.dart';
import 'package:medilink/features/reviews/domain/entities/review_entity.dart';
import 'package:medilink/features/reviews/domain/repositories/i_review_repository.dart';

class ReviewRepositoryImpl implements IReviewRepository {
  final ReviewRemoteDataSource _remoteDataSource;

  ReviewRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ReviewEntity>>> getReviews({
    required String reviewableId,
    required String reviewableType,
  }) async {
    try {
      final reviews = await _remoteDataSource.getReviews(
        reviewableId: reviewableId,
        reviewableType: reviewableType,
      );

      return Right(reviews.map((model) => model.toEntity()).toList());
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to fetch reviews: $e'));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> submitReview({
    required String reviewableId,
    required String reviewableType,
    required double rating,
    required String comment,
    List<String>? tags,
  }) async {
    try {
      final review = await _remoteDataSource.submitReview(
        reviewableId: reviewableId,
        reviewableType: reviewableType,
        rating: rating,
        comment: comment,
        tags: tags,
      );

      return Right(review.toEntity());
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to submit review: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markReviewHelpful(String reviewId) async {
    try {
      await _remoteDataSource.markReviewHelpful(reviewId);
      return const Right(null);
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to mark review helpful: $e'));
    }
  }
}
