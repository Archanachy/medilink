import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/reviews/domain/entities/review_entity.dart';
import 'package:medilink/features/reviews/domain/repositories/i_review_repository.dart';

class GetReviewsParams {
  final String reviewableId;
  final String reviewableType;

  const GetReviewsParams({
    required this.reviewableId,
    required this.reviewableType,
  });
}

class GetReviewsUsecase {
  final IReviewRepository _repository;

  GetReviewsUsecase(this._repository);

  Future<Either<Failure, List<ReviewEntity>>> call(
      GetReviewsParams params) async {
    return await _repository.getReviews(
      reviewableId: params.reviewableId,
      reviewableType: params.reviewableType,
    );
  }
}
