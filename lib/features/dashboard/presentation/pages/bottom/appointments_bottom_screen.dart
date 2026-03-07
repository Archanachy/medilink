import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/appointments/presentation/pages/appointments_list_screen.dart';

class AppointmentsBottomScreen extends ConsumerStatefulWidget {
  const AppointmentsBottomScreen({super.key});

  @override
  ConsumerState<AppointmentsBottomScreen> createState() =>
      _AppointmentsBottomScreenState();
}

class _AppointmentsBottomScreenState
    extends ConsumerState<AppointmentsBottomScreen> {
  @override
  Widget build(BuildContext context) {
    return const AppointmentsListScreen();
  }
}

