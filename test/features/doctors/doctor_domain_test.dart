import 'package:flutter_test/flutter_test.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_entity.dart';

void main() {
  test('DoctorEntity builds correctly', () {
    const entity = DoctorEntity(
      id: 'doc-1',
      firstName: 'Jane',
      lastName: 'Doe',
      fullName: 'Jane Doe',
      email: 'jane@example.com',
      specialization: 'Cardiology',
      experienceYears: 5,
      consultationFee: 500,
    );

    expect(entity.fullName, 'Jane Doe');
    expect(entity.specialization, 'Cardiology');
  });
}
