import 'package:equatable/equatable.dart';
import 'package:medilink/features/appointments/domain/entities/appointment_entity.dart';
import 'package:medilink/features/edit_profile/domain/enitities/user_profile_entity.dart';
import 'package:medilink/features/medical_records/domain/entities/medical_record_entity.dart';

enum DashboardStatus { initial, loading, success, error, refreshing }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final UserProfileEntity? user;
  final List<AppointmentEntity> upcomingAppointments;
  final List<MedicalRecordEntity> recentRecords;
  final int unreadNotifications;
  final String? errorMessage;
  final DateTime? lastUpdated;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.user,
    this.upcomingAppointments = const [],
    this.recentRecords = const [],
    this.unreadNotifications = 0,
    this.errorMessage,
    this.lastUpdated,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    UserProfileEntity? user,
    List<AppointmentEntity>? upcomingAppointments,
    List<MedicalRecordEntity>? recentRecords,
    int? unreadNotifications,
    String? errorMessage,
    DateTime? lastUpdated,
  }) {
    return DashboardState(
      status: status ?? this.status,
      user: user ?? this.user,
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
      recentRecords: recentRecords ?? this.recentRecords,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
      errorMessage: errorMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  bool get isLoading => status == DashboardStatus.loading;
  bool get isRefreshing => status == DashboardStatus.refreshing;
  bool get hasError => status == DashboardStatus.error;
  bool get hasData => user != null;

  @override
  List<Object?> get props => [
        status,
        user,
        upcomingAppointments,
        recentRecords,
        unreadNotifications,
        errorMessage,
        lastUpdated,
      ];
}
