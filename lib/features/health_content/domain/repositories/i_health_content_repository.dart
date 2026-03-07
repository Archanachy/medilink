import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/health_content/domain/entities/health_content_entity.dart';

abstract class IHealthContentRepository {
  Future<Either<Failure, List<HealthTipEntity>>> getHealthTips({String? category});
  Future<Either<Failure, HealthTipEntity>> getHealthTipById(String id);
  Future<Either<Failure, List<ArticleEntity>>> getArticles({String? category});
  Future<Either<Failure, ArticleEntity>> getArticleById(String id);
  Future<Either<Failure, List<String>>> getCategories();
}
