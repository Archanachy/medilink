import 'package:medilink/features/reviews/domain/entities/review_entity.dart';

class ReviewApiModel {
  final String id;
  final String userId;
  final String userName;
  final String userPhotoUrl;
  final String reviewableId;
  final String reviewableType;
  final double rating;
  final String comment;
  final List<String> tags;
  final bool isVerifiedVisit;
  final String visitDate;
  final String createdAt;
  final String updatedAt;
  final int helpfulCount;
  final bool isHelpful;

  ReviewApiModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhotoUrl,
    required this.reviewableId,
    required this.reviewableType,
    required this.rating,
    required this.comment,
    required this.tags,
    required this.isVerifiedVisit,
    required this.visitDate,
    required this.createdAt,
    required this.updatedAt,
    required this.helpfulCount,
    required this.isHelpful,
  });

  factory ReviewApiModel.fromJson(Map<String, dynamic> json) {
    return ReviewApiModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? 'Anonymous',
      userPhotoUrl: json['userPhotoUrl'] as String? ?? '',
      reviewableId: json['reviewableId'] as String? ?? '',
      reviewableType: json['reviewableType'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'] as String? ?? '',
      tags: json['tags'] != null
          ? List<String>.from(json['tags'] as List)
          : [],
      isVerifiedVisit: json['isVerifiedVisit'] as bool? ?? false,
      visitDate: json['visitDate'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      helpfulCount: json['helpfulCount'] as int? ?? 0,
      isHelpful: json['isHelpful'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'reviewableId': reviewableId,
      'reviewableType': reviewableType,
      'rating': rating,
      'comment': comment,
      'tags': tags,
      'isVerifiedVisit': isVerifiedVisit,
      'visitDate': visitDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'helpfulCount': helpfulCount,
      'isHelpful': isHelpful,
    };
  }

  ReviewEntity toEntity() {
    return ReviewEntity(
      id: id,
      userId: userId,
      userName: userName,
      userPhotoUrl: userPhotoUrl,
      reviewableId: reviewableId,
      reviewableType: reviewableType,
      rating: rating,
      comment: comment,
      tags: tags,
      isVerifiedVisit: isVerifiedVisit,
      visitDate: DateTime.tryParse(visitDate) ?? DateTime.now(),
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(updatedAt) ?? DateTime.now(),
      helpfulCount: helpfulCount,
      isHelpful: isHelpful,
    );
  }

  factory ReviewApiModel.fromEntity(ReviewEntity entity) {
    return ReviewApiModel(
      id: entity.id,
      userId: entity.userId,
      userName: entity.userName,
      userPhotoUrl: entity.userPhotoUrl,
      reviewableId: entity.reviewableId,
      reviewableType: entity.reviewableType,
      rating: entity.rating,
      comment: entity.comment,
      tags: entity.tags,
      isVerifiedVisit: entity.isVerifiedVisit,
      visitDate: entity.visitDate.toIso8601String(),
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      helpfulCount: entity.helpfulCount,
      isHelpful: entity.isHelpful,
    );
  }
}
