import 'package:medilink/features/availability/domain/entities/availability_entity.dart';

class AvailabilitySlotApiModel {
  final String id;
  final String doctorId;
  final String date;
  final String startTime;
  final String endTime;
  final bool isAvailable;
  final bool isRecurring;
  final String? recurringPattern;
  final String? recurringEndDate;
  final String? reason;
  final String createdAt;
  final String updatedAt;

  AvailabilitySlotApiModel({
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

  factory AvailabilitySlotApiModel.fromJson(Map<String, dynamic> json) {
    return AvailabilitySlotApiModel(
      id: json['id'] as String? ?? '',
      doctorId: json['doctorId'] as String? ?? '',
      date: json['date'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      isAvailable: json['isAvailable'] as bool? ?? true,
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurringPattern: json['recurringPattern'] as String?,
      recurringEndDate: json['recurringEndDate'] as String?,
      reason: json['reason'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'isAvailable': isAvailable,
      'isRecurring': isRecurring,
      'recurringPattern': recurringPattern,
      'recurringEndDate': recurringEndDate,
      'reason': reason,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  AvailabilitySlot toEntity() {
    return AvailabilitySlot(
      id: id,
      doctorId: doctorId,
      date: DateTime.tryParse(date) ?? DateTime.now(),
      startTime: startTime,
      endTime: endTime,
      isAvailable: isAvailable,
      isRecurring: isRecurring,
      recurringPattern: recurringPattern,
      recurringEndDate: recurringEndDate != null
          ? DateTime.tryParse(recurringEndDate!)
          : null,
      reason: reason,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(updatedAt) ?? DateTime.now(),
    );
  }

  factory AvailabilitySlotApiModel.fromEntity(AvailabilitySlot entity) {
    return AvailabilitySlotApiModel(
      id: entity.id,
      doctorId: entity.doctorId,
      date: entity.date.toIso8601String().split('T')[0],
      startTime: entity.startTime,
      endTime: entity.endTime,
      isAvailable: entity.isAvailable,
      isRecurring: entity.isRecurring,
      recurringPattern: entity.recurringPattern,
      recurringEndDate: entity.recurringEndDate?.toIso8601String().split('T')[0],
      reason: entity.reason,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }
}

class DoctorScheduleApiModel {
  final String doctorId;
  final List<AvailabilitySlotApiModel> slots;
  final String timezone;
  final Map<String, dynamic> weeklySchedule;
  final List<String> holidays;

  DoctorScheduleApiModel({
    required this.doctorId,
    required this.slots,
    required this.timezone,
    required this.weeklySchedule,
    required this.holidays,
  });

  factory DoctorScheduleApiModel.fromJson(Map<String, dynamic> json) {
    return DoctorScheduleApiModel(
      doctorId: json['doctorId'] as String? ?? '',
      slots: (json['slots'] as List<dynamic>?)
              ?.map((e) =>
                  AvailabilitySlotApiModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      timezone: json['timezone'] as String? ?? 'UTC',
      weeklySchedule: json['weeklySchedule'] as Map<String, dynamic>? ?? {},
      holidays: (json['holidays'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  DoctorSchedule toEntity() {
    final Map<String, List<String>> weeklyScheduleMap = {};
    weeklySchedule.forEach((key, value) {
      weeklyScheduleMap[key] =
          (value as List<dynamic>).map((e) => e as String).toList();
    });

    return DoctorSchedule(
      doctorId: doctorId,
      slots: slots.map((s) => s.toEntity()).toList(),
      timezone: timezone,
      weeklySchedule: weeklyScheduleMap,
      holidays: holidays.map((h) => DateTime.parse(h)).toList(),
    );
  }
}
