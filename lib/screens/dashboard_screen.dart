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
    return LayoutBuilder(
      builder: (context, constraints) {
        // 👉 Tablet check
        if (constraints.maxWidth >= 600) {
          return _buildTabletLayout();
        } else {
          return _buildMobileLayout();
        }
      },
    );
  }

  // 📱 MOBILE UI (Bottom Navigation)
  Widget _buildMobileLayout() {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
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
      ),
    );
  }

  // 📱 TABLET UI (Navigation Rail)
  Widget _buildTabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.calendar_month),
                label: Text('Appointments'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.description),
                label: Text('Records'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.history),
                label: Text('Activity'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: SafeArea(
  child: _screens[_currentIndex],
),

          ),
        ],
      ),
    );
  }
}
