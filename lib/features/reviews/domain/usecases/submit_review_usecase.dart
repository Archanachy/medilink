import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/reviews/domain/entities/review_entity.dart';
import 'package:medilink/features/reviews/domain/repositories/i_review_repository.dart';

class SubmitReviewParams {
  final String reviewableId;
  final String reviewableType;
  final double rating;
  final String comment;
  final List<String>? tags;

  const SubmitReviewParams({
    required this.reviewableId,
    required this.reviewableType,
    required this.rating,
    required this.comment,
    this.tags,
  });
}

class SubmitReviewUsecase {
  final IReviewRepository _repository;

  SubmitReviewUsecase(this._repository);

  Future<Either<Failure, ReviewEntity>> call(
      SubmitReviewParams params) async {
    return await _repository.submitReview(
      reviewableId: params.reviewableId,
      reviewableType: params.reviewableType,
      rating: params.rating,
      comment: params.comment,
      tags: params.tags,
    );
  }
}
