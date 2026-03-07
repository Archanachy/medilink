import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/appointments/data/repositories/appointment_repository_impl.dart';
import 'package:medilink/features/appointments/domain/entities/appointment_entity.dart';
import 'package:medilink/features/appointments/domain/repositories/appointment_repository.dart';

class BookAppointmentParams extends Equatable {
  final String doctorId;
  final String patientId;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String? reason;
  final String? symptoms;

  const BookAppointmentParams({
    required this.doctorId,
    required this.patientId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.reason,
    this.symptoms,
  });

  @override
  List<Object?> get props => [doctorId, patientId, date, startTime, endTime, reason, symptoms];
}

final bookAppointmentUsecaseProvider = Provider<BookAppointmentUsecase>((ref) {
  return BookAppointmentUsecase(ref.read(appointmentRepositoryProvider));
});

class BookAppointmentUsecase
    implements UsecaseWithParams<AppointmentEntity, BookAppointmentParams> {
  final IAppointmentRepository _repository;

  BookAppointmentUsecase(this._repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(BookAppointmentParams params) {
    return _repository.bookAppointment(
      doctorId: params.doctorId,
      patientId: params.patientId,
      date: params.date,
      startTime: params.startTime,
      endTime: params.endTime,
      reason: params.reason,
      symptoms: params.symptoms,
    );
  }
}
