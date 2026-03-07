import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/reviews/domain/repositories/i_review_repository.dart';

class MarkReviewHelpfulUsecase {
  final IReviewRepository _repository;

  MarkReviewHelpfulUsecase(this._repository);

  Future<Either<Failure, void>> call(String reviewId) async {
    return await _repository.markReviewHelpful(reviewId);
  }
}
