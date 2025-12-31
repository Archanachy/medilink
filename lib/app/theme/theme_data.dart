import 'package:flutter/material.dart';

// ------------------ Light & Dark themes ------------------

ThemeData getLightTheme() {
  const seed = Colors.deepPurple;
  return ThemeData(
    colorScheme:
        ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
    useMaterial3: true,
    fontFamily: "OpenSans Regular",
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 16),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
    iconTheme: const IconThemeData(color: seed),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Color(0xFF000000)),
      hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
    ),
    appBarTheme: const AppBarTheme(centerTitle: true),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: seed,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: Colors.white),
  );
}

ThemeData getDarkTheme() {
  const seed = Colors.deepPurple;
  return ThemeData(
    colorScheme:
        ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
    useMaterial3: true,
    fontFamily: "OpenSans Regular",
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 16),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
    // slightly translucent dark drawer to match dark surface
    drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF121212)),
    iconTheme: IconThemeData(color: seed.shade200),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Color(0xFFFFFFFF)),
      hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
      // dark-friendly filled fields are common:
      filled: true,
      fillColor: Color(0xFF1E1E1E),
    ),
    appBarTheme: const AppBarTheme(centerTitle: true),
    scaffoldBackgroundColor: const Color(0xFF0B0B0B),
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: Color(0xFF0A0A0A)),
  );
}
