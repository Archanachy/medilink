import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/appointments/presentation/pages/appointments_list_screen.dart';
import 'package:medilink/features/appointments/presentation/states/appointment_state.dart';
import 'package:medilink/features/appointments/presentation/view_model/appointment_view_model.dart';

class MockUserSessionService extends Mock implements UserSessionService {}

class FakeAppointmentViewModel extends AppointmentViewModel {
  final AppointmentState _initial;
  FakeAppointmentViewModel(this._initial);

  @override
  AppointmentState build() => _initial;

  @override
  Future<void> fetchAppointments({String? userId, String? status}) async {
    // no-op for widget tests
  }
}

void main() {
  late MockUserSessionService mockUserSessionService;

  setUp(() {
    mockUserSessionService = MockUserSessionService();
    when(() => mockUserSessionService.getCurrentUserId()).thenReturn('user-1');
    when(() => mockUserSessionService.getCurrentPatientId()).thenReturn('patient-1');
  });

  testWidgets('Appointments list screen renders', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userSessionServiceProvider
              .overrideWith((ref) => mockUserSessionService),
          appointmentViewModelProvider.overrideWith(
            () => FakeAppointmentViewModel(
              const AppointmentState(
                status: AppointmentStatus.success,
                appointments: [],
              ),
            ),
          ),
        ],
        child: const MaterialApp(home: AppointmentsListScreen()),
      ),
    );
    expect(find.text('Appointments'), findsOneWidget);
  });

  testWidgets('Appointments list screen shows notification action', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userSessionServiceProvider
              .overrideWith((ref) => mockUserSessionService),
          appointmentViewModelProvider.overrideWith(
            () => FakeAppointmentViewModel(
              const AppointmentState(
                status: AppointmentStatus.success,
                appointments: [],
              ),
            ),
          ),
        ],
        child: const MaterialApp(home: AppointmentsListScreen()),
      ),
    );

    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
  });
}
