import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/core/api/api_endpoints.dart';
import 'package:medilink/features/reviews/data/models/review_api_model.dart';

class ReviewRemoteDataSource {
  final ApiClient _apiClient;

  ReviewRemoteDataSource(this._apiClient);

  Future<List<ReviewApiModel>> getReviews({
    required String reviewableId,
    required String reviewableType,
  }) async {
    // Only doctors have reviews (hospitals feature was removed)
    final endpoint = ApiEndpoints.reviewsByDoctor(reviewableId);

    final response = await _apiClient.get(endpoint);

    if (response.data is Map && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((json) => ReviewApiModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  Future<ReviewApiModel> submitReview({
    required String reviewableId,
    required String reviewableType,
    required double rating,
    required String comment,
    List<String>? tags,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.reviews,
      data: {
        'reviewableId': reviewableId,
        'reviewableType': reviewableType,
        'rating': rating,
        'comment': comment,
        'tags': tags ?? [],
      },
    );

    return ReviewApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> markReviewHelpful(String reviewId) async {
    await _apiClient.post('${ApiEndpoints.reviews}/$reviewId/helpful');
  }
}
