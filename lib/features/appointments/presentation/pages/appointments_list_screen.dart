import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/appointments/presentation/states/appointment_state.dart';
import 'package:medilink/features/appointments/presentation/view_model/appointment_view_model.dart';
import 'package:medilink/features/appointments/presentation/widgets/appointment_card_widget.dart';

class AppointmentsListScreen extends ConsumerStatefulWidget {
  const AppointmentsListScreen({super.key});

  @override
  ConsumerState<AppointmentsListScreen> createState() => _AppointmentsListScreenState();
}

class _AppointmentsListScreenState extends ConsumerState<AppointmentsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get current user ID from session to fetch appointments
      final userSessionService = ref.read(userSessionServiceProvider);
      final userId = userSessionService.getCurrentUserId();
      final patientId = userSessionService.getCurrentPatientId();
      
      if (userId != null && userId.isNotEmpty) {
        ref.read(appointmentViewModelProvider.notifier).fetchAppointments(userId: userId);
      } else if (patientId != null && patientId.isNotEmpty) {
        ref.read(appointmentViewModelProvider.notifier).fetchAppointments(userId: patientId);
      } else {
        // Fallback: try without userId (may fail with 403 but shows error message)
        ref.read(appointmentViewModelProvider.notifier).fetchAppointments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Builder(
          builder: (context) {
            if (state.status == AppointmentStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == AppointmentStatus.error) {
              return Center(
                child: Text(state.errorMessage ?? 'Failed to load appointments'),
              );
            }
            if (state.appointments.isEmpty) {
              return const Center(child: Text('No appointments found'));
            }

            return ListView.builder(
              itemCount: state.appointments.length,
              itemBuilder: (context, index) {
                final appointment = state.appointments[index];
                return AppointmentCardWidget(
                  appointment: appointment,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/appointment-detail',
                      arguments: appointment.id,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
