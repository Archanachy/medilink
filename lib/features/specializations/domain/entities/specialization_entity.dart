import 'package:equatable/equatable.dart';

class SpecializationEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final int doctorCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SpecializationEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.doctorCount,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        iconUrl,
        doctorCount,
        isActive,
        createdAt,
        updatedAt,
      ];

  SpecializationEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? iconUrl,
    int? doctorCount,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SpecializationEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      doctorCount: doctorCount ?? this.doctorCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
