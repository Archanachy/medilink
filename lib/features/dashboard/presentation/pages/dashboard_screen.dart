import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/appointments/presentation/pages/appointments_list_screen.dart';
import 'package:medilink/features/chat/presentation/pages/conversation_list_screen.dart';
import 'package:medilink/features/dashboard/presentation/pages/bottom/appointments_bottom_screen.dart';
import 'package:medilink/features/dashboard/presentation/pages/bottom/doctors_bottom_screen.dart';
import 'package:medilink/features/dashboard/presentation/pages/bottom/home_bottom_screen.dart';
import 'package:medilink/features/dashboard/presentation/pages/bottom/profile_bottom_screen.dart';


class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}


class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;

  List<Widget> _patientScreens() => const [
        HomeBottomScreen(),
        AppointmentsBottomScreen(),
        DoctorsBottomScreen(),
        ProfileBottomScreen(),
      ];

  List<Widget> _doctorScreens() => const [
        AppointmentsListScreen(),
        ConversationListScreen(),
        ProfileBottomScreen(),
      ];

  bool _isDoctorUser() {
    final role = ref.read(userSessionServiceProvider).getCurrentUserRole();
    return (role ?? '').toLowerCase() == 'doctor';
  }

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

  //  MOBILE UI (Bottom Navigation)
  Widget _buildMobileLayout() {
    final isDoctor = _isDoctorUser();
    final screens = isDoctor ? _doctorScreens() : _patientScreens();
    final safeIndex = _currentIndex >= screens.length ? screens.length - 1 : _currentIndex;

    return Scaffold(
      body: screens[safeIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: safeIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 10,
        iconSize: 22,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: isDoctor
            ? const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Appointments',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_outline),
                  label: 'Messages',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ]
            : const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Appointments',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_search),
                  label: 'Doctors',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
      ),
    );
  }

  // TABLET UI (Navigation Rail)
  Widget _buildTabletLayout() {
    final isDoctor = _isDoctorUser();
    final screens = isDoctor ? _doctorScreens() : _patientScreens();
    final safeIndex = _currentIndex >= screens.length ? screens.length - 1 : _currentIndex;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: safeIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: isDoctor
                ? const [
                    NavigationRailDestination(
                      icon: Icon(Icons.calendar_today),
                      label: Text('Appointments'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.chat_bubble_outline),
                      label: Text('Messages'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person),
                      label: Text('Profile'),
                    ),
                  ]
                : const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.calendar_today),
                      label: Text('Appointments'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_search),
                      label: Text('Doctors'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person),
                      label: Text('Profile'),
                    ),
                  ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: screens[safeIndex],
          ),
        ],
      ),
    );
  }
}