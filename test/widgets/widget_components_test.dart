import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_entity.dart';
import 'package:medilink/features/doctors/presentation/widgets/doctor_card.dart';

void main() {
  testWidgets('DoctorCard renders name', (tester) async {
    const doctor = DoctorEntity(
      id: '1',
      firstName: 'Sara',
      lastName: 'Lee',
      fullName: 'Sara Lee',
      email: 'sara@example.com',
      specialization: 'Dermatology',
      experienceYears: 7,
      consultationFee: 400,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: DoctorCard(doctor: doctor)),
      ),
    );

    expect(find.text('Sara Lee'), findsOneWidget);
  });

  testWidgets('DoctorCard renders specialization and consultation fee', (tester) async {
    const doctor = DoctorEntity(
      id: '1',
      firstName: 'Sara',
      lastName: 'Lee',
      fullName: 'Sara Lee',
      email: 'sara@example.com',
      specialization: 'Dermatology',
      experienceYears: 7,
      consultationFee: 400,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: DoctorCard(doctor: doctor)),
      ),
    );

    expect(find.text('Dermatology'), findsOneWidget);
    expect(find.text('Rs 400'), findsOneWidget);
  });
}
