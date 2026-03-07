import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/health_content/data/datasources/health_content_remote_data_source.dart';
import 'package:medilink/features/health_content/domain/entities/health_content_entity.dart';
import 'package:medilink/features/health_content/domain/repositories/i_health_content_repository.dart';

class HealthContentRepositoryImpl implements IHealthContentRepository {
  final HealthContentRemoteDataSource _remoteDataSource;

  HealthContentRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<HealthTipEntity>>> getHealthTips(
      {String? category}) async {
    try {
      final tips = await _remoteDataSource.getHealthTips(category: category);
      return Right(tips.map((t) => t.toEntity()).toList());
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to fetch health tips'));
    }
  }

  @override
  Future<Either<Failure, HealthTipEntity>> getHealthTipById(String id) async {
    try {
      final tip = await _remoteDataSource.getHealthTipById(id);
      return Right(tip.toEntity());
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to fetch health tip'));
    }
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> getArticles(
      {String? category}) async {
    try {
      final articles = await _remoteDataSource.getArticles(category: category);
      return Right(articles.map((a) => a.toEntity()).toList());
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to fetch articles'));
    }
  }

  @override
  Future<Either<Failure, ArticleEntity>> getArticleById(String id) async {
    try {
      final article = await _remoteDataSource.getArticleById(id);
      return Right(article.toEntity());
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to fetch article'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final categories = await _remoteDataSource.getCategories();
      return Right(categories);
    } on ApiFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to fetch categories: $e'));
    }
  }
}
