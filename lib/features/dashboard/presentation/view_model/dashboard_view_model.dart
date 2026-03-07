import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/appointments/domain/entities/appointment_entity.dart';
import 'package:medilink/features/appointments/domain/usecases/get_appointments_usecase.dart';
import 'package:medilink/features/dashboard/presentation/states/dashboard_state.dart';
import 'package:medilink/features/edit_profile/domain/usecases/get_patient_by_user_id_usecase.dart';
import 'package:medilink/features/medical_records/domain/usecases/get_records_usecase.dart';

final dashboardViewModelProvider =
    NotifierProvider<DashboardViewModel, DashboardState>(
  DashboardViewModel.new,
);

class DashboardViewModel extends Notifier<DashboardState> {
  late final GetPatientByUserIdUsecase _getPatientByUserIdUsecase;
  late final GetAppointmentsUsecase _getAppointmentsUsecase;
  late final GetRecordsUsecase _getRecordsUsecase;
  late final UserSessionService _userSessionService;
  String? _currentUserId;
  String? _currentPatientId;

  @override
  DashboardState build() {
    _getPatientByUserIdUsecase = ref.read(getPatientByUserIdUsecaseProvider);
    _getAppointmentsUsecase = ref.read(getAppointmentsUsecaseProvider);
    _getRecordsUsecase = ref.read(getRecordsUsecaseProvider);
    _userSessionService = ref.read(userSessionServiceProvider);
    
    return const DashboardState();
  }

  /// Public method to initialize dashboard on first load
  Future<void> initialize() async {
    final userId = _userSessionService.getCurrentUserId();
    if (userId != null) {
      _currentUserId = userId;
      await loadDashboardData();
    } else {
      state = state.copyWith(
        status: DashboardStatus.error,
        errorMessage: 'User session not found. Please login again.',
      );
    }
  }

  Future<void> loadDashboardData({bool isRefresh = false}) async {
    if (isRefresh) {
      state = state.copyWith(status: DashboardStatus.refreshing);
    } else {
      state = state.copyWith(status: DashboardStatus.loading);
    }

    _currentUserId ??= _userSessionService.getCurrentUserId();

    if (_currentUserId == null) {
      state = state.copyWith(
        status: DashboardStatus.error,
        errorMessage: 'User session not found. Please login again.',
      );
      return;
    }

    try {
      // Load user profile only for patients (doctors don't have patient profiles)
      final userRole = _userSessionService.getCurrentUserRole();
      if (userRole?.toLowerCase() == 'patient') {
        await _loadUserProfile();
      }

      // Load appointments and records in parallel
      await Future.wait([
        _loadUpcomingAppointments(),
        _loadRecentRecords(),
      ]);

      state = state.copyWith(
        status: DashboardStatus.success,
        lastUpdated: DateTime.now(),
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: DashboardStatus.error,
        errorMessage: 'Failed to load dashboard data: ${e.toString()}',
      );
    }
  }

  Future<void> _loadUserProfile() async {
    final result = await _getPatientByUserIdUsecase(_currentUserId!);

    result.fold(
      (failure) {
        // If profile fails to load, we continue with other data
        // but log the error
        if (kDebugMode) {
          debugPrint('Failed to load profile: ${failure.message}');
        }
      },
      (profile) {
        _currentPatientId = profile.patientId;
        state = state.copyWith(user: profile);
      },
    );
  }

  Future<void> _loadUpcomingAppointments() async {
    if (_currentUserId == null) return;

    final params = GetAppointmentsParams(
      userId: _currentUserId!,
      status: 'upcoming',
      limit: 5, // Only get next 5 appointments for dashboard
    );

    final result = await _getAppointmentsUsecase(params);

    result.fold(
      (failure) {
        if (kDebugMode) {
          debugPrint('Failed to load appointments: ${failure.message}');
        }
        // Don't set error state, just log
      },
      (appointments) {
        final filteredAppointments = _filterUpcomingAppointments(appointments);
        state = state.copyWith(upcomingAppointments: filteredAppointments);
      },
    );
  }

  List<AppointmentEntity> _filterUpcomingAppointments(List<AppointmentEntity> appointments) {
    final now = DateTime.now();
    final allowedStatuses = {'scheduled', 'confirmed', 'upcoming'};

    final filtered = appointments.where((appointment) {
      final normalizedStatus = appointment.status.toString().toLowerCase().trim();
      final isUpcomingStatus = allowedStatuses.contains(normalizedStatus);
      final isFutureOrNow = !appointment.appointmentDate.toLocal().isBefore(now);

      return isUpcomingStatus && isFutureOrNow;
    }).toList();

    filtered.sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));

    if (kDebugMode) {
      debugPrint(
        'Dashboard appointments: total=${appointments.length}, upcoming=${filtered.length}',
      );
    }

    return filtered.take(5).toList();
  }

  Future<void> _loadRecentRecords() async {
    if (_currentPatientId == null) return;

    final params = GetRecordsParams(
      patientId: _currentPatientId!,
      limit: 3, // Only get 3 most recent records
    );

    final result = await _getRecordsUsecase(params);

    result.fold(
      (failure) {
        if (kDebugMode) {
          debugPrint('Failed to load records: ${failure.message}');
        }
        // Don't set error state, just log
      },
      (records) {
        state = state.copyWith(recentRecords: records);
      },
    );
  }

  Future<void> refresh() async {
    await loadDashboardData(isRefresh: true);
  }

  void clearError() {
    state = state.copyWith(
      errorMessage: null,
      status: DashboardStatus.initial,
    );
  }
}
