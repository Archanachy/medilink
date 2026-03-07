import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/appointments/domain/entities/appointment_entity.dart';
import 'package:medilink/features/appointments/presentation/states/appointment_state.dart';
import 'package:medilink/features/appointments/presentation/view_model/appointment_view_model.dart';

class ConversationListScreen extends ConsumerStatefulWidget {
  const ConversationListScreen({super.key});

  @override
  ConsumerState<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends ConsumerState<ConversationListScreen> {
  String? _currentUserId;
  String? _currentUserRole;

  @override
  void initState() {
    super.initState();
    
    // Initialize synchronously to avoid null role during first build
    final userSessionService = ref.read(userSessionServiceProvider);
    _currentUserId = userSessionService.getCurrentUserId();
    _currentUserRole = userSessionService.getCurrentUserRole();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      if (_currentUserId != null) {
        ref.read(appointmentViewModelProvider.notifier).fetchAppointments(
              userId: _currentUserId,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentViewModelProvider);
    final isDoctor = _currentUserRole?.toLowerCase() == 'doctor';
    
    final contacts = isDoctor 
        ? _extractPatients(appointmentState.appointments)
        : _extractDoctors(appointmentState.appointments);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (!mounted) return;
          if (_currentUserId != null) {
            await ref.read(appointmentViewModelProvider.notifier).fetchAppointments(
                  userId: _currentUserId,
                );
          }
        },
        child: Builder(
          builder: (context) {
            if (appointmentState.status == AppointmentStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (appointmentState.status == AppointmentStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                    const SizedBox(height: 16),
                    Text(
                      appointmentState.errorMessage ?? 'Failed to load doctors for chat',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (!mounted) return;
                        if (_currentUserId != null) {
                          ref.read(appointmentViewModelProvider.notifier).fetchAppointments(
                                userId: _currentUserId,
                              );
                        }
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (contacts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      isDoctor 
                          ? 'No patients available to message'
                          : 'No doctors available to message',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isDoctor
                          ? 'Patients will appear when they book appointments'
                          : 'Book an appointment to start chatting',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: contacts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 1),
              itemBuilder: (context, index) {
                final contact = contacts[index];

                return Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      if (_currentUserId == null || _currentUserId!.isEmpty) {
                        return;
                      }

                      Navigator.pushNamed(
                        context,
                        '/chat',
                        arguments: {
                          'userId': _currentUserId,
                          'conversationId': contact.id,
                          'receiverId': contact.id,
                          'receiverName': contact.name,
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              _getInitials(contact.name),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contact.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  contact.subtitle.isEmpty
                                      ? (isDoctor ? 'Patient' : 'Doctor')
                                      : contact.subtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<_ChatContactItem> _extractDoctors(List<AppointmentEntity> appointments) {
    final byDoctorId = <String, _ChatContactItem>{};

    for (final appointment in appointments) {
      final doctorId = appointment.doctorId.trim();
      if (doctorId.isEmpty) continue;

      final doctorName = appointment.doctorName.trim().isEmpty
          ? 'Doctor'
          : appointment.doctorName.trim();
      final specialization = (appointment.doctorSpecialization ?? '').trim();

      byDoctorId[doctorId] = _ChatContactItem(
        id: doctorId,
        name: doctorName,
        subtitle: specialization,
      );
    }

    return byDoctorId.values.toList();
  }

  List<_ChatContactItem> _extractPatients(List<AppointmentEntity> appointments) {
    final byPatientId = <String, _ChatContactItem>{};

    for (final appointment in appointments) {
      final patientId = appointment.patientId.trim();
      if (patientId.isEmpty) continue;

      final patientName = appointment.patientName.trim().isEmpty
          ? 'Patient'
          : appointment.patientName.trim();

      byPatientId[patientId] = _ChatContactItem(
        id: patientId,
        name: patientName,
        subtitle: '', // Patients don't have specialization
      );
    }

    return byPatientId.values.toList();
  }

  String _getInitials(String fullName) {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'D';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();

    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}

class _ChatContactItem {
  final String id;
  final String name;
  final String subtitle;

  const _ChatContactItem({
    required this.id,
    required this.name,
    required this.subtitle,
  });
}
