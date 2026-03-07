import 'package:medilink/features/vitals/domain/entities/vitals_entity.dart';

class VitalsApiModel {
  final String id;
  final String patientId;
  final String vitalType;
  final double value;
  final double? secondaryValue;
  final String unit;
  final String recordedAt;
  final String? notes;
  final String createdAt;

  VitalsApiModel({
    required this.id,
    required this.patientId,
    required this.vitalType,
    required this.value,
    this.secondaryValue,
    required this.unit,
    required this.recordedAt,
    this.notes,
    required this.createdAt,
  });

  factory VitalsApiModel.fromJson(Map<String, dynamic> json) {
    return VitalsApiModel(
      id: json['id'] as String? ?? '',
      patientId: json['patientId'] as String? ?? '',
      vitalType: json['vitalType'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      secondaryValue: (json['secondaryValue'] as num?)?.toDouble(),
      unit: json['unit'] as String? ?? '',
      recordedAt: json['recordedAt'] as String? ?? '',
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'vitalType': vitalType,
      'value': value,
      'secondaryValue': secondaryValue,
      'unit': unit,
      'recordedAt': recordedAt,
      'notes': notes,
      'createdAt': createdAt,
    };
  }

  VitalsEntity toEntity() {
    return VitalsEntity(
      id: id,
      patientId: patientId,
      vitalType: vitalType,
      value: value,
      secondaryValue: secondaryValue,
      unit: unit,
      recordedAt: DateTime.tryParse(recordedAt) ?? DateTime.now(),
      notes: notes,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
    );
  }

  factory VitalsApiModel.fromEntity(VitalsEntity entity) {
    return VitalsApiModel(
      id: entity.id,
      patientId: entity.patientId,
      vitalType: entity.vitalType,
      value: entity.value,
      secondaryValue: entity.secondaryValue,
      unit: entity.unit,
      recordedAt: entity.recordedAt.toIso8601String(),
      notes: entity.notes,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}
