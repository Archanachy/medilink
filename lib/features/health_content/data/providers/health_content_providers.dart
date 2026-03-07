import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/features/health_content/data/datasources/health_content_remote_data_source.dart';
import 'package:medilink/features/health_content/data/repositories/health_content_repository_impl.dart';
import 'package:medilink/features/health_content/domain/repositories/i_health_content_repository.dart';
import 'package:medilink/features/health_content/domain/usecases/health_content_usecases.dart';

// Data source
final healthContentRemoteDataSourceProvider =
    Provider<HealthContentRemoteDataSource>((ref) {
  return HealthContentRemoteDataSource(ref.watch(apiClientProvider));
});

// Repository
final healthContentRepositoryProvider = Provider<IHealthContentRepository>((ref) {
  return HealthContentRepositoryImpl(
      ref.watch(healthContentRemoteDataSourceProvider));
});

// Use cases
final getHealthTipsUsecaseProvider = Provider<GetHealthTipsUsecase>((ref) {
  return GetHealthTipsUsecase(ref.watch(healthContentRepositoryProvider));
});

final getHealthTipByIdUsecaseProvider = Provider<GetHealthTipByIdUsecase>((ref) {
  return GetHealthTipByIdUsecase(ref.watch(healthContentRepositoryProvider));
});

final getArticlesUsecaseProvider = Provider<GetArticlesUsecase>((ref) {
  return GetArticlesUsecase(ref.watch(healthContentRepositoryProvider));
});

final getArticleByIdUsecaseProvider = Provider<GetArticleByIdUsecase>((ref) {
  return GetArticleByIdUsecase(ref.watch(healthContentRepositoryProvider));
});

final getCategoriesUsecaseProvider = Provider<GetCategoriesUsecase>((ref) {
  return GetCategoriesUsecase(ref.watch(healthContentRepositoryProvider));
});
