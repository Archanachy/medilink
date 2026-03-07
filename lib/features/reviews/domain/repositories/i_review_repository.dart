import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/reviews/domain/entities/review_entity.dart';

abstract class IReviewRepository {
  Future<Either<Failure, List<ReviewEntity>>> getReviews({
    required String reviewableId,
    required String reviewableType,
  });
  
  Future<Either<Failure, ReviewEntity>> submitReview({
    required String reviewableId,
    required String reviewableType,
    required double rating,
    required String comment,
    List<String>? tags,
  });
  
  Future<Either<Failure, void>> markReviewHelpful(String reviewId);
}
