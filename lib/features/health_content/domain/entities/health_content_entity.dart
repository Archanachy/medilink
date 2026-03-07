import 'package:equatable/equatable.dart';

class HealthTipEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final String category;
  final String iconUrl;
  final DateTime publishedAt;

  const HealthTipEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.iconUrl,
    required this.publishedAt,
  });

  @override
  List<Object?> get props => [id, title, content, category, iconUrl, publishedAt];
}

class ArticleEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final String summary;
  final String category;
  final String author;
  final String imageUrl;
  final List<String> tags;
  final int readTime; // in minutes
  final DateTime publishedAt;
  final DateTime updatedAt;

  const ArticleEntity({
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

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        summary,
        category,
        author,
        imageUrl,
        tags,
        readTime,
        publishedAt,
        updatedAt,
      ];
}
