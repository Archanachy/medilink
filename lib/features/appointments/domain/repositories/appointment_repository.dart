import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/appointments/domain/entities/appointment_entity.dart';

abstract interface class IAppointmentRepository {
  Future<Either<Failure, AppointmentEntity>> bookAppointment({
    required String doctorId,
    required String patientId,
    required DateTime date,
    required String startTime,
    required String endTime,
    String? reason,
    String? symptoms,
  });

  Future<Either<Failure, List<AppointmentEntity>>> getAppointments({
    String? userId,
    String? status,
    int? page,
    int? limit,
  });

  Future<Either<Failure, bool>> cancelAppointment({
    required String appointmentId,
    String? reason,
  });
}
