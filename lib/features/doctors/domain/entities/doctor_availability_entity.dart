import 'package:equatable/equatable.dart';

class DoctorAvailabilityEntity extends Equatable {
  final String doctorId;
  final String date;
  final List<String> availableSlots;

  const DoctorAvailabilityEntity({
    required this.doctorId,
    required this.date,
    required this.availableSlots,
  });

  @override
  List<Object?> get props => [doctorId, date, availableSlots];
}
