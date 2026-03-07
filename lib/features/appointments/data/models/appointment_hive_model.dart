import 'package:hive/hive.dart';
import 'package:medilink/core/constants/hive_table_constant.dart';
import 'package:medilink/features/appointments/domain/entities/appointment_entity.dart';

part 'appointment_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.appointmentTypeId)
class AppointmentHiveModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String patientId;
  @HiveField(2)
  final String doctorId;
  @HiveField(3)
  final String patientName;
  @HiveField(4)
  final String doctorName;
  @HiveField(5)
  final DateTime appointmentDate;
  @HiveField(6)
  final String startTime;
  @HiveField(7)
  final String endTime;
  @HiveField(8)
  final String status;
  @HiveField(9)
  final String? reason;
  @HiveField(10)
  final String? location;
  @HiveField(11)
  final double consultationFee;
  @HiveField(12)
  final DateTime? createdAt;

  AppointmentHiveModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.patientName,
    required this.doctorName,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.reason,
    this.location,
    required this.consultationFee,
    this.createdAt,
  });

  factory AppointmentHiveModel.fromEntity(AppointmentEntity entity) {
    return AppointmentHiveModel(
      id: entity.id,
      patientId: entity.patientId,
      doctorId: entity.doctorId,
      patientName: entity.patientName,
      doctorName: entity.doctorName,
      appointmentDate: entity.appointmentDate,
      startTime: entity.startTime,
      endTime: entity.endTime,
      status: entity.status,
      reason: entity.reason,
      location: entity.location,
      consultationFee: entity.consultationFee,
      createdAt: entity.createdAt,
    );
  }

  AppointmentEntity toEntity() {
    return AppointmentEntity(
      id: id,
      patientId: patientId,
      doctorId: doctorId,
      patientName: patientName,
      doctorName: doctorName,
      appointmentDate: appointmentDate,
      startTime: startTime,
      endTime: endTime,
      status: status,
      reason: reason,
      location: location,
      consultationFee: consultationFee,
      createdAt: createdAt,
    );
  }
}
