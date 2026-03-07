import 'package:medilink/features/health_content/domain/entities/health_content_entity.dart';

enum HealthContentStatus {
  idle,
  loading,
  loaded,
  error,
}

class HealthContentState {
  final HealthContentStatus status;
  final List<HealthTipEntity> healthTips;
  final List<ArticleEntity> articles;
  final List<String> categories;
  final String? selectedCategory;
  final bool isLoading;
  final String? error;

  const HealthContentState({
    this.status = HealthContentStatus.idle,
    this.healthTips = const [],
    this.articles = const [],
    this.categories = const [],
    this.selectedCategory,
    this.isLoading = false,
    this.error,
  });

  HealthContentState copyWith({
    HealthContentStatus? status,
    List<HealthTipEntity>? healthTips,
    List<ArticleEntity>? articles,
    List<String>? categories,
    String? selectedCategory,
    bool? isLoading,
    String? error,
  }) {
    return HealthContentState(
      status: status ?? this.status,
      healthTips: healthTips ?? this.healthTips,
      articles: articles ?? this.articles,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  HealthContentState clearError() {
    return copyWith(error: null);
  }
}
