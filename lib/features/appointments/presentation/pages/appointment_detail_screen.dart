import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/appointments/presentation/states/appointment_state.dart';
import 'package:medilink/features/appointments/presentation/view_model/appointment_view_model.dart';
import 'package:medilink/features/prescriptions/presentation/pages/create_prescription_screen.dart';

class AppointmentDetailScreen extends ConsumerStatefulWidget {
  final String appointmentId;

  const AppointmentDetailScreen({
    super.key,
    required this.appointmentId,
  });

  @override
  ConsumerState<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState
    extends ConsumerState<AppointmentDetailScreen> {
  bool _isCancelling = false;

  bool _isScheduled(String? status) {
    final normalized = (status ?? '').trim().toLowerCase();
    return normalized == 'scheduled';
  }

  bool _canIssuePrescription(String? status) {
    final normalized = (status ?? '').trim().toLowerCase();
    return normalized == 'scheduled' ||
        normalized == 'confirmed' ||
        normalized == 'completed';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAppointmentDetails();
    });
  }

  Future<void> _loadAppointmentDetails() async {
    final viewModel = ref.read(appointmentViewModelProvider.notifier);
    final session = ref.read(userSessionServiceProvider);
    final currentState = ref.read(appointmentViewModelProvider);

    if (currentState.appointments.isEmpty) {
      final userId =
          session.getCurrentUserId() ?? session.getCurrentPatientId();
      await viewModel.fetchAppointments(userId: userId);
    }

    viewModel.selectAppointment(widget.appointmentId);
  }

  Future<void> _cancelAppointment(String appointmentId) async {
    setState(() {
      _isCancelling = true;
    });

    final success =
        await ref.read(appointmentViewModelProvider.notifier).cancelAppointment(
              appointmentId: appointmentId,
            );

    setState(() {
      _isCancelling = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            success ? 'Appointment cancelled' : 'Failed to cancel appointment'),
      ),
    );

    if (success) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentViewModelProvider);
    final appointment = state.selectedAppointment;

    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Builder(
          builder: (context) {
            if (state.status == AppointmentStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == AppointmentStatus.error) {
              return Center(
                child: Text(state.errorMessage ?? 'Failed to load appointment'),
              );
            }
            if (appointment == null) {
              return const Center(child: Text('Appointment not found'));
            }

            final userRole =
                ref.read(userSessionServiceProvider).getCurrentUserRole();
            final isDoctor = userRole?.toLowerCase() == 'doctor';

            // Doctors see patient as main header, patients see doctor as main header
            final mainName =
                isDoctor ? appointment.patientName : appointment.doctorName;
            final secondaryLabel = isDoctor ? 'Doctor' : 'Patient';
            final secondaryName =
                isDoctor ? appointment.doctorName : appointment.patientName;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mainName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('$secondaryLabel: $secondaryName'),
                const SizedBox(height: 8),
                Text(
                  'Date: ${appointment.appointmentDate.toLocal().toString().split(' ')[0]}',
                ),
                const SizedBox(height: 8),
                Text('Time: ${appointment.startTime} - ${appointment.endTime}'),
                const SizedBox(height: 8),
                Text('Status: ${appointment.status}'),
                const SizedBox(height: 8),
                Text('Reason: ${appointment.reason ?? 'N/A'}'),
                const Spacer(),
                if (isDoctor && _canIssuePrescription(appointment.status)) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final created = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreatePrescriptionScreen(
                              patientId: appointment.patientId,
                              patientName: appointment.patientName,
                              doctorId: appointment.doctorId,
                              doctorName: appointment.doctorName,
                              appointmentId: appointment.id,
                            ),
                          ),
                        );

                        if (!mounted || created != true) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Prescription issued for appointment'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Issue Prescription',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (_isScheduled(appointment.status)) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final userId = ref
                                .read(userSessionServiceProvider)
                                .getCurrentUserId() ??
                            appointment.patientId;

                        // Doctors chat with patients, patients chat with doctors
                        final chatReceiverId = isDoctor
                            ? appointment.patientId
                            : appointment.doctorId;
                        final chatReceiverName = isDoctor
                            ? appointment.patientName
                            : appointment.doctorName;

                        Navigator.pushNamed(
                          context,
                          '/chat',
                          arguments: {
                            'userId': userId,
                            'conversationId': chatReceiverId,
                            'receiverId': chatReceiverId,
                            'receiverName': chatReceiverName,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Send Message',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isCancelling
                          ? null
                          : () => _cancelAppointment(appointment.id),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: _isCancelling
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Cancel Appointment'),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
