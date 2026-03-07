import 'package:equatable/equatable.dart';

class VitalsEntity extends Equatable {
  final String id;
  final String patientId;
  final String vitalType; // 'blood_pressure', 'heart_rate', 'blood_sugar', 'weight', 'temperature', 'oxygen'
  final double value;
  final double? secondaryValue; // For systolic/diastolic BP
  final String unit;
  final DateTime recordedAt;
  final String? notes;
  final DateTime createdAt;

  const VitalsEntity({
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

  @override
  List<Object?> get props => [
        id,
        patientId,
        vitalType,
        value,
        secondaryValue,
        unit,
        recordedAt,
        notes,
        createdAt,
      ];

  bool get isNormal {
    switch (vitalType) {
      case 'blood_pressure':
        return value >= 90 && value <= 120 && (secondaryValue ?? 0) >= 60 && (secondaryValue ?? 0) <= 80;
      case 'heart_rate':
        return value >= 60 && value <= 100;
      case 'blood_sugar':
        return value >= 70 && value <= 140;
      case 'temperature':
        return value >= 36.1 && value <= 37.2;
      case 'oxygen':
        return value >= 95 && value <= 100;
      default:
        return true;
    }
  }

  String get statusLabel {
    if (isNormal) return 'Normal';

    switch (vitalType) {
      case 'blood_pressure':
        if (value > 120 || (secondaryValue ?? 0) > 80) return 'High';
        return 'Low';
      case 'heart_rate':
        if (value > 100) return 'High';
        return 'Low';
      case 'blood_sugar':
        if (value > 140) return 'High';
        return 'Low';
      case 'temperature':
        if (value > 37.2) return 'Fever';
        return 'Low';
      case 'oxygen':
        return 'Low';
      default:
        return '';
    }
  }
}
