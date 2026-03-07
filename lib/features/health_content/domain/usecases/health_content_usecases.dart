import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/health_content/domain/entities/health_content_entity.dart';
import 'package:medilink/features/health_content/domain/repositories/i_health_content_repository.dart';

class GetHealthTipsUsecase {
  final IHealthContentRepository _repository;

  GetHealthTipsUsecase(this._repository);

  Future<Either<Failure, List<HealthTipEntity>>> call({String? category}) async {
    return await _repository.getHealthTips(category: category);
  }
}

class GetHealthTipByIdUsecase {
  final IHealthContentRepository _repository;

  GetHealthTipByIdUsecase(this._repository);

  Future<Either<Failure, HealthTipEntity>> call(String id) async {
    return await _repository.getHealthTipById(id);
  }
}

class GetArticlesUsecase {
  final IHealthContentRepository _repository;

  GetArticlesUsecase(this._repository);

  Future<Either<Failure, List<ArticleEntity>>> call({String? category}) async {
    return await _repository.getArticles(category: category);
  }
}

class GetArticleByIdUsecase {
  final IHealthContentRepository _repository;

  GetArticleByIdUsecase(this._repository);

  Future<Either<Failure, ArticleEntity>> call(String id) async {
    return await _repository.getArticleById(id);
  }
}

class GetCategoriesUsecase {
  final IHealthContentRepository _repository;

  GetCategoriesUsecase(this._repository);

  Future<Either<Failure, List<String>>> call() async {
    return await _repository.getCategories();
  }
}
