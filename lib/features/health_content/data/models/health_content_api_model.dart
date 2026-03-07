import 'package:medilink/features/health_content/domain/entities/health_content_entity.dart';

class HealthTipApiModel {
  final String id;
  final String title;
  final String content;
  final String category;
  final String iconUrl;
  final String publishedAt;

  HealthTipApiModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.iconUrl,
    required this.publishedAt,
  });

  factory HealthTipApiModel.fromJson(Map<String, dynamic> json) {
    return HealthTipApiModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      category: json['category'] as String? ?? '',
      iconUrl: json['iconUrl'] as String? ?? '',
      publishedAt: json['publishedAt'] as String? ?? '',
    );
  }

  HealthTipEntity toEntity() {
    return HealthTipEntity(
      id: id,
      title: title,
      content: content,
      category: category,
      iconUrl: iconUrl,
      publishedAt: DateTime.tryParse(publishedAt) ?? DateTime.now(),
    );
  }
}

class ArticleApiModel {
  final String id;
  final String title;
  final String content;
  final String summary;
  final String category;
  final String author;
  final String imageUrl;
  final List<String> tags;
  final int readTime;
  final String publishedAt;
  final String updatedAt;

  ArticleApiModel({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.category,
    required this.author,
    required this.imageUrl,
    required this.tags,
    required this.readTime,
    required this.publishedAt,
    required this.updatedAt,
  });

  factory ArticleApiModel.fromJson(Map<String, dynamic> json) {
    return ArticleApiModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      category: json['category'] as String? ?? '',
      author: json['author'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      readTime: json['readTime'] as int? ?? 5,
      publishedAt: json['publishedAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  ArticleEntity toEntity() {
    return ArticleEntity(
      id: id,
      title: title,
      content: content,
      summary: summary,
      category: category,
      author: author,
      imageUrl: imageUrl,
      tags: tags,
      readTime: readTime,
      publishedAt: DateTime.tryParse(publishedAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(updatedAt) ?? DateTime.now(),
    );
  }
}
