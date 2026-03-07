import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medilink/features/appointments/presentation/pages/appointments_list_screen.dart';

void main() {
  testWidgets('Appointments list screen renders', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: AppointmentsListScreen()),
      ),
    );
    expect(find.text('Appointments'), findsOneWidget);
  });
}
