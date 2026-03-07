import 'package:medilink/features/appointments/domain/entities/appointment_entity.dart';

class AppointmentApiModel {
  final String id;
  final String patientId;
  final String doctorId;
  final String patientName;
  final String doctorName;
  final String? doctorSpecialization;
  final DateTime appointmentDate;
  final String startTime;
  final String endTime;
  final String status;
  final String? reason;
  final String? location;
  final double consultationFee;
  final DateTime? createdAt;

  AppointmentApiModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.patientName,
    required this.doctorName,
    this.doctorSpecialization,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.reason,
    this.location,
    required this.consultationFee,
    this.createdAt,
  });

  factory AppointmentApiModel.fromJson(Map<String, dynamic> json) {
    // Extract patient info (might be populated object or ID string)
    String patientId = '';
    String patientName = '';
    if (json['patientId'] != null) {
      if (json['patientId'] is Map<String, dynamic>) {
        final patient = json['patientId'] as Map<String, dynamic>;
        patientId = patient['_id'] as String? ?? '';
        final firstName = patient['firstName'] as String? ?? '';
        final lastName = patient['lastName'] as String? ?? '';
        patientName = '$firstName $lastName'.trim();
      } else {
        patientId = json['patientId'] as String? ?? '';
      }
    }

    // Extract doctor info (might be populated object or ID string)
    String doctorId = '';
    String doctorName = '';
    String? doctorSpecialization;
    double consultationFee = 0.0;
    if (json['doctorId'] != null) {
      if (json['doctorId'] is Map<String, dynamic>) {
        final doctor = json['doctorId'] as Map<String, dynamic>;
        doctorId = doctor['_id'] as String? ?? '';
        final firstName = doctor['firstName'] as String? ?? '';
        final lastName = doctor['lastName'] as String? ?? '';
        doctorName = '$firstName $lastName'.trim();
        doctorSpecialization = doctor['specialization'] as String?;
        consultationFee = (doctor['consultationFee'] as num?)?.toDouble() ?? 0.0;
      } else {
        doctorId = json['doctorId'] as String? ?? '';
      }
    }

    // Parse appointment date (check both field names)
    DateTime appointmentDate = DateTime.now();
    final dateStr = json['appointment_date'] as String? ?? json['appointmentDate'] as String?;
    if (dateStr != null) {
      try {
        appointmentDate = DateTime.parse(dateStr);
      } catch (e) {
        // Keep default value if parsing fails
      }
    }

    // Calculate startTime and endTime from appointment date and duration
    String startTime = '';
    String endTime = '';
    final localDate = appointmentDate.toLocal();
    startTime = '${localDate.hour.toString().padLeft(2, '0')}:${localDate.minute.toString().padLeft(2, '0')}';
    
    // Add duration to get end time
    final duration = json['duration'] as int? ?? 30;
    final endDateTime = localDate.add(Duration(minutes: duration));
    endTime = '${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}';

    return AppointmentApiModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      patientId: patientId,
      doctorId: doctorId,
      patientName: patientName.isEmpty ? (json['patientName'] as String? ?? '') : patientName,
      doctorName: doctorName.isEmpty ? (json['doctorName'] as String? ?? '') : doctorName,
      doctorSpecialization: doctorSpecialization,
      appointmentDate: appointmentDate,
      startTime: startTime,
      endTime: endTime,
      status: json['status'] as String? ?? 'scheduled',
      reason: json['reason'] as String?,
      location: json['location'] as String?,
      consultationFee: consultationFee > 0 ? consultationFee : (json['consultationFee'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : (json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'appointmentDate': appointmentDate.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'reason': reason,
    };
  }

  AppointmentEntity toEntity() {
    return AppointmentEntity(
      id: id,
      patientId: patientId,
      doctorId: doctorId,
      patientName: patientName,
      doctorName: doctorName,
      doctorSpecialization: doctorSpecialization,
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

  static List<AppointmentEntity> toEntityList(List<AppointmentApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
