import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  double batteryLevel = 0.0;

  @override
  void initState() {
    super.initState();
    _animateBattery();
  }

  void _animateBattery() {
    Future.delayed(const Duration(milliseconds: 500), () async {
      for (double i = 0; i <= 1; i += 0.02) {
        await Future.delayed(const Duration(milliseconds: 50));
        setState(() {
          batteryLevel = i;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to login screen
        Navigator.pushReplacementNamed(context, "/onboarding");

      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Medical Shield Icon
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade50,
                ),
                child: Icon(
                  Icons.health_and_safety,
                  size: 80,
                  color: Colors.blue.shade800,
                ),
              ),

              const SizedBox(height: 30),

              // App Title
              const Text(
                "Your Health, Simplified.",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 40),
              Container(
                width: 180,
                height: 35,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: batteryLevel,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              Text(
                "${(batteryLevel * 100).toInt()}%",
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 30),

              Text(
                "Tap to continue",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
