import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String userPhotoUrl;
  final String reviewableId; // Doctor or Hospital ID
  final String reviewableType; // 'doctor' or 'hospital'
  final double rating;
  final String comment;
  final List<String> tags;
  final bool isVerifiedVisit;
  final DateTime visitDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int helpfulCount;
  final bool isHelpful;

  const ReviewEntity({
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

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userPhotoUrl,
        reviewableId,
        reviewableType,
        rating,
        comment,
        tags,
        isVerifiedVisit,
        visitDate,
        createdAt,
        updatedAt,
        helpfulCount,
        isHelpful,
      ];

  ReviewEntity copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    String? reviewableId,
    String? reviewableType,
    double? rating,
    String? comment,
    List<String>? tags,
    bool? isVerifiedVisit,
    DateTime? visitDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? helpfulCount,
    bool? isHelpful,
  }) {
    return ReviewEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      reviewableId: reviewableId ?? this.reviewableId,
      reviewableType: reviewableType ?? this.reviewableType,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      tags: tags ?? this.tags,
      isVerifiedVisit: isVerifiedVisit ?? this.isVerifiedVisit,
      visitDate: visitDate ?? this.visitDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      isHelpful: isHelpful ?? this.isHelpful,
    );
  }
}
