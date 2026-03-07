import 'package:equatable/equatable.dart';

class DoctorReviewEntity extends Equatable {
  final String id;
  final String doctorId;
  final String patientId;
  final String patientName;
  final double rating;
  final String? comment;
  final DateTime createdAt;

  const DoctorReviewEntity({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.patientName,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id, doctorId, patientId, patientName, rating, comment, createdAt,
  ];
}
