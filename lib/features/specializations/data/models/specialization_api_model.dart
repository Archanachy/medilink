import 'package:medilink/features/specializations/domain/entities/specialization_entity.dart';

class SpecializationApiModel {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final int doctorCount;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  SpecializationApiModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.doctorCount,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SpecializationApiModel.fromJson(Map<String, dynamic> json) {
    return SpecializationApiModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconUrl: json['iconUrl'] as String? ?? '',
      doctorCount: json['doctorCount'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
      'doctorCount': doctorCount,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  SpecializationEntity toEntity() {
    return SpecializationEntity(
      id: id,
      name: name,
      description: description,
      iconUrl: iconUrl,
      doctorCount: doctorCount,
      isActive: isActive,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(updatedAt) ?? DateTime.now(),
    );
  }

  factory SpecializationApiModel.fromEntity(SpecializationEntity entity) {
    return SpecializationApiModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      iconUrl: entity.iconUrl,
      doctorCount: entity.doctorCount,
      isActive: entity.isActive,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }
}
