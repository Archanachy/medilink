import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/appointments/data/repositories/appointment_repository_impl.dart';
import 'package:medilink/features/appointments/domain/entities/appointment_entity.dart';
import 'package:medilink/features/appointments/domain/repositories/appointment_repository.dart';

class GetAppointmentsParams extends Equatable {
  final String? userId;
  final String? status;
  final int? page;
  final int? limit;

  const GetAppointmentsParams({
    this.userId,
    this.status,
    this.page,
    this.limit,
  });

  @override
  List<Object?> get props => [userId, status, page, limit];
}

final getAppointmentsUsecaseProvider = Provider<GetAppointmentsUsecase>((ref) {
  return GetAppointmentsUsecase(ref.read(appointmentRepositoryProvider));
});

class GetAppointmentsUsecase
    implements UsecaseWithParams<List<AppointmentEntity>, GetAppointmentsParams> {
  final IAppointmentRepository _repository;

  GetAppointmentsUsecase(this._repository);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(GetAppointmentsParams params) {
    return _repository.getAppointments(
      userId: params.userId,
      status: params.status,
      page: params.page,
      limit: params.limit,
    );
  }
}
