import 'package:flutter_test/flutter_test.dart';
import 'package:medilink/features/appointments/domain/usecases/get_appointments_usecase.dart';

void main() {
  test('GetAppointmentsParams stores values', () {
    const params = GetAppointmentsParams(userId: 'u1', status: 'pending');
    expect(params.userId, 'u1');
    expect(params.status, 'pending');
  });
}
