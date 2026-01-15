import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/app/app.dart';
import 'package:medilink/core/services/hive/hive_service.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService().init();
  final sharedprefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(overrides: [
    sharedPreferencesProvider.overrideWithValue(sharedprefs),
  ], child: const MediLinkApp()));
}
