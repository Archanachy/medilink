import 'package:flutter_test/flutter_test.dart';
import 'package:medilink/features/appointments/domain/entities/appointment_entity.dart';

void main() {
  test('AppointmentEntity props include status', () {
    final entity = AppointmentEntity(
      id: 'apt-1',
      patientId: 'p1',
      doctorId: 'd1',
      patientName: 'Patient',
      doctorName: 'Doctor',
      appointmentDate: DateTime(2026, 2, 27),
      startTime: '10:00',
      endTime: '10:30',
      status: 'pending',
      consultationFee: 300,
    );

    expect(entity.status, 'pending');
  });
}
