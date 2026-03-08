import 'package:flutter_test/flutter_test.dart';
import 'package:medilink/features/appointments/domain/usecases/book_appointment_usecase.dart';
import 'package:medilink/features/appointments/domain/usecases/cancel_appointment_usecase.dart';
import 'package:medilink/features/appointments/domain/usecases/get_appointments_usecase.dart';

void main() {
  test('GetAppointmentsParams stores values', () {
    const params = GetAppointmentsParams(userId: 'u1', status: 'pending');
    expect(params.userId, 'u1');
    expect(params.status, 'pending');
  });

  test('GetAppointmentsParams stores pagination values', () {
    const params = GetAppointmentsParams(
      userId: 'u1',
      status: 'completed',
      page: 2,
      limit: 20,
    );
    expect(params.page, 2);
    expect(params.limit, 20);
    expect(params.props, ['u1', 'completed', 2, 20]);
  });

  test('CancelAppointmentParams stores appointmentId and reason', () {
    const params = CancelAppointmentParams(
      appointmentId: 'appt-1',
      reason: 'Patient requested cancellation',
    );
    expect(params.appointmentId, 'appt-1');
    expect(params.reason, 'Patient requested cancellation');
    expect(params.props, ['appt-1', 'Patient requested cancellation']);
  });

  test('BookAppointmentParams stores doctor and patient scheduling data', () {
    final date = DateTime(2026, 3, 10);
    final params = BookAppointmentParams(
      doctorId: 'doc-1',
      patientId: 'pat-1',
      date: date,
      startTime: '10:00',
      endTime: '10:30',
      reason: 'Follow-up',
      symptoms: 'Headache',
    );
    expect(params.doctorId, 'doc-1');
    expect(params.patientId, 'pat-1');
    expect(params.date, date);
    expect(params.startTime, '10:00');
    expect(params.endTime, '10:30');
    expect(params.reason, 'Follow-up');
    expect(params.symptoms, 'Headache');
  });

  test('GetAppointmentsParams equality works for same values', () {
    const first = GetAppointmentsParams(
      userId: 'u1',
      status: 'pending',
      page: 1,
      limit: 10,
    );
    const second = GetAppointmentsParams(
      userId: 'u1',
      status: 'pending',
      page: 1,
      limit: 10,
    );
    expect(first, second);
    expect(first.hashCode, second.hashCode);
  });

  test('CancelAppointmentParams supports null reason', () {
    const params = CancelAppointmentParams(appointmentId: 'appt-99');
    expect(params.appointmentId, 'appt-99');
    expect(params.reason, isNull);
    expect(params.props, ['appt-99', null]);
  });

  test('BookAppointmentParams supports null optional fields', () {
    final params = BookAppointmentParams(
      doctorId: 'doc-2',
      patientId: 'pat-2',
      date: DateTime(2026, 4, 12),
      startTime: '14:00',
      endTime: '14:30',
    );
    expect(params.reason, isNull);
    expect(params.symptoms, isNull);
  });

  test('BookAppointmentParams equality works for same values', () {
    final date = DateTime(2026, 4, 12);
    final first = BookAppointmentParams(
      doctorId: 'doc-2',
      patientId: 'pat-2',
      date: date,
      startTime: '14:00',
      endTime: '14:30',
      reason: 'Checkup',
      symptoms: 'Cough',
    );
    final second = BookAppointmentParams(
      doctorId: 'doc-2',
      patientId: 'pat-2',
      date: date,
      startTime: '14:00',
      endTime: '14:30',
      reason: 'Checkup',
      symptoms: 'Cough',
    );
    expect(first, second);
  });
}
