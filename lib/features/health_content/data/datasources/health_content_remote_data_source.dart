import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/core/api/api_endpoints.dart';
import 'package:medilink/features/health_content/data/models/health_content_api_model.dart';

class HealthContentRemoteDataSource {
  final ApiClient _apiClient;

  HealthContentRemoteDataSource(this._apiClient);

  Future<List<HealthTipApiModel>> getHealthTips({String? category}) async {
    final queryParams = <String, dynamic>{};
    if (category != null) {
      queryParams['category'] = category;
    }

    final response = await _apiClient.get(
      ApiEndpoints.healthTips,
      queryParameters: queryParams,
    );

    final tips = (response.data['data'] as List<dynamic>)
        .map((e) => HealthTipApiModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return tips;
  }

  Future<HealthTipApiModel> getHealthTipById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.healthTipById(id));

    return HealthTipApiModel.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  Future<List<ArticleApiModel>> getArticles({String? category}) async {
    final queryParams = <String, dynamic>{};
    if (category != null) {
      queryParams['category'] = category;
    }

    final response = await _apiClient.get(
      ApiEndpoints.articles,
      queryParameters: queryParams,
    );

    final articles = (response.data['data'] as List<dynamic>)
        .map((e) => ArticleApiModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return articles;
  }

  Future<ArticleApiModel> getArticleById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.articleById(id));

    return ArticleApiModel.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  Future<List<String>> getCategories() async {
    final response = await _apiClient.get(ApiEndpoints.healthTipsCategories);

    return (response.data['data'] as List<dynamic>)
        .map((e) => e as String)
        .toList();
  }
}
