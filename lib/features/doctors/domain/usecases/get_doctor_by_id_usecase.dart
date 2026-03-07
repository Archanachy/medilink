import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/doctors/data/repositories/doctor_repository_impl.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_entity.dart';
import 'package:medilink/features/doctors/domain/repositories/doctor_repository.dart';

class GetDoctorByIdParams extends Equatable {
  final String doctorId;

  const GetDoctorByIdParams({required this.doctorId});

  @override
  List<Object?> get props => [doctorId];
}

final getDoctorByIdUsecaseProvider = Provider<GetDoctorByIdUsecase>((ref) {
  return GetDoctorByIdUsecase(ref.read(doctorRepositoryProvider));
});

class GetDoctorByIdUsecase implements UsecaseWithParams<DoctorEntity, GetDoctorByIdParams> {
  final IDoctorRepository _repository;

  GetDoctorByIdUsecase(this._repository);

  @override
  Future<Either<Failure, DoctorEntity>> call(GetDoctorByIdParams params) {
    return _repository.getDoctorById(params.doctorId);
  }
}
