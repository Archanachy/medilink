import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_entity.dart';
import 'package:medilink/features/doctors/domain/usecases/get_doctor_by_id_usecase.dart';
import 'package:medilink/features/doctors/domain/usecases/get_doctors_usecase.dart';
import 'package:medilink/features/doctors/presentation/states/doctor_state.dart';

final doctorViewModelProvider = NotifierProvider<DoctorViewModel, DoctorState>(
  DoctorViewModel.new,
);

class DoctorViewModel extends Notifier<DoctorState> {
  late final GetDoctorsUsecase _getDoctorsUsecase;
  late final GetDoctorByIdUsecase _getDoctorByIdUsecase;

  @override
  DoctorState build() {
    _getDoctorsUsecase = ref.read(getDoctorsUsecaseProvider);
    _getDoctorByIdUsecase = ref.read(getDoctorByIdUsecaseProvider);
    return const DoctorState();
  }

  Future<void> fetchDoctors({
    String? specialization,
    String? searchQuery,
    int? page,
    int? limit,
  }) async {
    state = state.copyWith(
      status: DoctorStatus.loading,
      specializationFilter: specialization,
      searchQuery: searchQuery,
    );

    final params = GetDoctorsParams(
      page: page,
      limit: limit,
    );

    final result = await _getDoctorsUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: DoctorStatus.error,
          errorMessage: failure.message,
        );
      },
      (doctors) {
        final filteredDoctors = _applyLocalFilters(
          doctors,
          searchQuery: searchQuery,
          specialization: specialization,
        );

        state = state.copyWith(
          status: DoctorStatus.success,
          allDoctors: doctors,
          doctors: filteredDoctors,
          errorMessage: null,
        );
      },
    );
  }

  void updateFilters({String? specialization, String? searchQuery}) {
    final filteredDoctors = _applyLocalFilters(
      state.allDoctors,
      searchQuery: searchQuery,
      specialization: specialization,
    );

    state = state.copyWith(
      status: DoctorStatus.success,
      doctors: filteredDoctors,
      specializationFilter: specialization,
      searchQuery: searchQuery,
      errorMessage: null,
    );
  }

  List<String> _normalizeSpecializationValues(String specialization) {
    return specialization
        .split(',')
        .map((item) => item.trim().toLowerCase())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  List<DoctorEntity> _applyLocalFilters(
    List<DoctorEntity> doctors, {
    String? specialization,
    String? searchQuery,
  }) {
    final normalizedQuery = (searchQuery ?? '').trim().toLowerCase();
    final specializationFilters = _normalizeSpecializationValues(specialization ?? '');

    return doctors.where((doctor) {
      final matchesSearch = normalizedQuery.isEmpty ||
          doctor.fullName.toLowerCase().contains(normalizedQuery) ||
          doctor.specialization.toLowerCase().contains(normalizedQuery);

      final matchesSpecialization = specializationFilters.isEmpty ||
          specializationFilters.any(
            (filter) => doctor.specialization.toLowerCase().contains(filter),
          );

      return matchesSearch && matchesSpecialization;
    }).toList();
  }

  Future<void> fetchDoctorById(String id) async {
    state = state.copyWith(status: DoctorStatus.loading);

    final params = GetDoctorByIdParams(doctorId: id);
    final result = await _getDoctorByIdUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: DoctorStatus.error,
          errorMessage: failure.message,
        );
      },
      (doctor) {
        state = state.copyWith(
          status: DoctorStatus.success,
          selectedDoctor: doctor,
          errorMessage: null,
        );
      },
    );
  }

  void clearSelection() {
    state = state.copyWith(selectedDoctor: null);
  }
}
