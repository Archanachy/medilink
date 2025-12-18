import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,

    // 🔹 your existing font (kept as you requested)
    fontFamily: "OpenSans Regular",

    // 🔹 ADDED: global text theme (mobile + tablet)
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),

    // 🔹 ADDED: drawer theme (useful for tablet)
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
    ),

    // 🔹 ADDED: icon theme
    iconTheme: const IconThemeData(
      color: Colors.deepPurple,
    ),

    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: Color(0xFF000000),
      ),
      hintStyle: TextStyle(
        color: Color(0xFFFFFFFF),
      ),
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),

    scaffoldBackgroundColor: Colors.white,

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
    ),
  );
}
