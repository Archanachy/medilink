import 'package:flutter/material.dart';
import 'package:medilink/screens/bottom/acitivity_bottom_screen.dart';
import 'package:medilink/screens/bottom/appointments_bottom_screen.dart';
import 'package:medilink/screens/bottom/home_bottom_screen.dart';
import 'package:medilink/screens/bottom/record_bottom_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeBottomScreen(),
    AppointmentsBottomScreen(),
    RecordBottomScreen(),
    ActivityBottomScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color.fromARGB(255, 235, 208, 240),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: const Color.fromARGB(255, 97, 96, 96),

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Activity',
          ),
        ],
        //  bottom navigation integration

      ),
    );
  }
}
