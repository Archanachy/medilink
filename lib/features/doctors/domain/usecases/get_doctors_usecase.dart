import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/doctors/data/repositories/doctor_repository_impl.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_entity.dart';
import 'package:medilink/features/doctors/domain/repositories/doctor_repository.dart';

class GetDoctorsParams extends Equatable {
  final String? specialization;
  final String? searchQuery;
  final int? page;
  final int? limit;

  const GetDoctorsParams({
    this.specialization,
    this.searchQuery,
    this.page,
    this.limit,
  });

  @override
  List<Object?> get props => [specialization, searchQuery, page, limit];
}

final getDoctorsUsecaseProvider = Provider<GetDoctorsUsecase>((ref) {
  return GetDoctorsUsecase(ref.read(doctorRepositoryProvider));
});

class GetDoctorsUsecase implements UsecaseWithParams<List<DoctorEntity>, GetDoctorsParams> {
  final IDoctorRepository _repository;

  GetDoctorsUsecase(this._repository);

  @override
  Future<Either<Failure, List<DoctorEntity>>> call(GetDoctorsParams params) {
    return _repository.getDoctors(
      specialization: params.specialization,
      searchQuery: params.searchQuery,
      page: params.page,
      limit: params.limit,
    );
  }
}
