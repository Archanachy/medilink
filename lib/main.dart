import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/app/app.dart';
import 'package:medilink/core/services/hive/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(hiveServiceProvider).init();
  runApp(UncontrolledProviderScope(container: container, child: const MediLinkApp()));
}
