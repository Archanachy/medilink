import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/appointments/domain/entities/appointment_entity.dart';

class AppointmentCardWidget extends ConsumerWidget {
  final AppointmentEntity appointment;
  final VoidCallback? onTap;

  const AppointmentCardWidget({
    super.key,
    required this.appointment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.read(userSessionServiceProvider).getCurrentUserRole();
    final isDoctor = userRole?.toLowerCase() == 'doctor';
    
    // Doctors see patient names, patients see doctor names
    final displayName = isDoctor ? appointment.patientName : appointment.doctorName;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.event_available),
        title: Text(displayName),
        subtitle: Text(
          '${appointment.appointmentDate.toLocal().toString().split(' ')[0]} • ${appointment.startTime}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              appointment.status.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                color: appointment.status == 'cancelled' ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Rs ${appointment.consultationFee.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
