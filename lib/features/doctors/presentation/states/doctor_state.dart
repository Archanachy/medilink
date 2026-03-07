import 'package:equatable/equatable.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_entity.dart';

enum DoctorStatus { initial, loading, success, error }

const Object _doctorStateUnset = Object();

class DoctorState extends Equatable {
  final DoctorStatus status;
  final List<DoctorEntity> allDoctors;
  final List<DoctorEntity> doctors;
  final DoctorEntity? selectedDoctor;
  final String? errorMessage;
  final String? specializationFilter;
  final String? searchQuery;

  const DoctorState({
    this.status = DoctorStatus.initial,
    this.allDoctors = const [],
    this.doctors = const [],
    this.selectedDoctor,
    this.errorMessage,
    this.specializationFilter,
    this.searchQuery,
  });

  DoctorState copyWith({
    DoctorStatus? status,
    List<DoctorEntity>? allDoctors,
    List<DoctorEntity>? doctors,
    Object? selectedDoctor = _doctorStateUnset,
    Object? errorMessage = _doctorStateUnset,
    Object? specializationFilter = _doctorStateUnset,
    Object? searchQuery = _doctorStateUnset,
  }) {
    return DoctorState(
      status: status ?? this.status,
      allDoctors: allDoctors ?? this.allDoctors,
      doctors: doctors ?? this.doctors,
      selectedDoctor: selectedDoctor == _doctorStateUnset
          ? this.selectedDoctor
          : selectedDoctor as DoctorEntity?,
      errorMessage: errorMessage == _doctorStateUnset
          ? this.errorMessage
          : errorMessage as String?,
      specializationFilter: specializationFilter == _doctorStateUnset
          ? this.specializationFilter
          : specializationFilter as String?,
      searchQuery: searchQuery == _doctorStateUnset
          ? this.searchQuery
          : searchQuery as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allDoctors,
    doctors,
    selectedDoctor,
    errorMessage,
    specializationFilter,
    searchQuery,
  ];
}
