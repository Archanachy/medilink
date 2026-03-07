import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medilink/features/doctors/presentation/pages/doctors_list_screen.dart';

void main() {
  testWidgets('Doctors list screen renders', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: DoctorsListScreen()),
      ),
    );
    expect(find.text('Doctors'), findsOneWidget);
  });
}
