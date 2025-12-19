import 'package:flutter/material.dart';

class AppointmentsBottomScreen extends StatelessWidget {
  const AppointmentsBottomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isTablet = width >= 600;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_month,
                size: isTablet ? 120 : 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                "Welcome",
                style: TextStyle(
                  fontSize: isTablet ? 30 : 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "This is your appointments screen",
                style: TextStyle(
                  fontSize: isTablet ? 18 : 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
