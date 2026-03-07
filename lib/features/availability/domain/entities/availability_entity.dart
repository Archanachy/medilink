import 'package:equatable/equatable.dart';

class AvailabilitySlot extends Equatable {
  final String id;
  final String doctorId;
  final DateTime date;
  final String startTime; // Format: "HH:mm"
  final String endTime; // Format: "HH:mm"
  final bool isAvailable;
  final bool isRecurring;
  final String? recurringPattern; // 'daily', 'weekly', 'monthly'
  final DateTime? recurringEndDate;
  final String? reason; // For time-off/holidays
  final DateTime createdAt;
  final DateTime updatedAt;

  const AvailabilitySlot({
    required this.id,
    required this.doctorId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    required this.isRecurring,
    this.recurringPattern,
    this.recurringEndDate,
    this.reason,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        doctorId,
        date,
        startTime,
        endTime,
        isAvailable,
        isRecurring,
        recurringPattern,
        recurringEndDate,
        reason,
        createdAt,
        updatedAt,
      ];

  AvailabilitySlot copyWith({
    String? id,
    String? doctorId,
    DateTime? date,
    String? startTime,
    String? endTime,
    bool? isAvailable,
    bool? isRecurring,
    String? recurringPattern,
    DateTime? recurringEndDate,
    String? reason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AvailabilitySlot(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPattern: recurringPattern ?? this.recurringPattern,
      recurringEndDate: recurringEndDate ?? this.recurringEndDate,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class DoctorSchedule extends Equatable {
  final String doctorId;
  final List<AvailabilitySlot> slots;
  final String timezone;
  final Map<String, List<String>> weeklySchedule; // day -> [time slots]
  final List<DateTime> holidays;

  const DoctorSchedule({
    required this.doctorId,
    required this.slots,
    required this.timezone,
    required this.weeklySchedule,
    required this.holidays,
  });

  @override
  List<Object?> get props =>
      [doctorId, slots, timezone, weeklySchedule, holidays];
}
