import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/appointments/data/repositories/appointment_repository_impl.dart';
import 'package:medilink/features/appointments/domain/repositories/appointment_repository.dart';

class CancelAppointmentParams extends Equatable {
  final String appointmentId;
  final String? reason;

  const CancelAppointmentParams({
    required this.appointmentId,
    this.reason,
  });

  @override
  List<Object?> get props => [appointmentId, reason];
}

final cancelAppointmentUsecaseProvider = Provider<CancelAppointmentUsecase>((ref) {
  return CancelAppointmentUsecase(ref.read(appointmentRepositoryProvider));
});

class CancelAppointmentUsecase
    implements UsecaseWithParams<bool, CancelAppointmentParams> {
  final IAppointmentRepository _repository;

  CancelAppointmentUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call(CancelAppointmentParams params) {
    return _repository.cancelAppointment(
      appointmentId: params.appointmentId,
      reason: params.reason,
    );
  }
}
