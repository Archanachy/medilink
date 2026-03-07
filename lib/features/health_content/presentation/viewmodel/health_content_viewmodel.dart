import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/health_content/data/providers/health_content_providers.dart';
import 'package:medilink/features/health_content/presentation/state/health_content_state.dart';

class HealthContentViewmodel extends Notifier<HealthContentState> {
  @override
  HealthContentState build() {
    // Auto-load content on initialization
    Future.microtask(() {
      loadCategories();
      loadHealthTips();
      loadArticles();
    });
    return const HealthContentState();
  }

  Future<void> loadCategories() async {
    final usecase = ref.read(getCategoriesUsecaseProvider);
    final result = await usecase();

    result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
      },
      (categories) {
        state = state.copyWith(categories: categories, error: null);
      },
    );
  }

  Future<void> loadHealthTips({String? category}) async {
    state = state.copyWith(
      isLoading: true,
      status: HealthContentStatus.loading,
      selectedCategory: category,
    );

    final usecase = ref.read(getHealthTipsUsecaseProvider);
    final result = await usecase(category: category);

    result.fold(
      (failure) {
        // Health tips endpoint is not available on this backend
        // Display empty list instead of error
        state = state.copyWith(
          isLoading: false,
          status: HealthContentStatus.loaded,
          healthTips: const [],
          error: null,
        );
      },
      (tips) {
        state = state.copyWith(
          isLoading: false,
          status: HealthContentStatus.loaded,
          healthTips: tips,
          error: null,
        );
      },
    );
  }

  Future<void> loadArticles({String? category}) async {
    state = state.copyWith(
      isLoading: true,
      status: HealthContentStatus.loading,
      selectedCategory: category,
    );

    final usecase = ref.read(getArticlesUsecaseProvider);
    final result = await usecase(category: category);

    result.fold(
      (failure) {
        // Articles endpoint is not available on this backend
        // Display empty list instead of error
        state = state.copyWith(
          isLoading: false,
          status: HealthContentStatus.loaded,
          articles: const [],
          error: null,
        );
      },
      (articles) {
        state = state.copyWith(
          isLoading: false,
          status: HealthContentStatus.loaded,
          articles: articles,
          error: null,
        );
      },
    );
  }

  void setCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
    loadHealthTips(category: category);
    loadArticles(category: category);
  }

  void clearError() {
    state = state.clearError();
  }
}
