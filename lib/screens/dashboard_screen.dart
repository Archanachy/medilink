import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Good Morning,', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      SizedBox(height: 5),
                      Text('Puja Chaudhary', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Upcoming Appointment Card
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Upcoming Appointment', style: TextStyle(fontSize: 16, color: Colors.grey)),
                            SizedBox(height: 5),
                            Text('Dr. Evelyn Reed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text('12 Dec, 2025 | 10:00 AM', style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 18),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Quick Actions Grid
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 2,
                ),
                children: [
                  _quickActionButton(icon: Icons.local_hospital, label: 'Find a Doctor', onTap: () {}),
                  _quickActionButton(icon: Icons.calendar_today, label: 'Appointment Book', onTap: () {}),
                  _quickActionButton(icon: Icons.folder, label: 'My Records', onTap: () {}),
                  _quickActionButton(icon: Icons.history, label: 'Recent Activity', notification: 3, onTap: () {}),
                ],
              ),
              const SizedBox(height: 20),

              // Chat & More Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _chatOptionButton(Icons.chat, 'Chat', onTap: () {}),
                  _chatOptionButton(Icons.more_horiz, 'More', onTap: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for Quick Action Button
  Widget _quickActionButton({required IconData icon, required String label, int notification = 0, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36, color: Colors.blue),
                const SizedBox(height: 10),
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ],
            ),
            if (notification > 0)
              Positioned(
                top: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text('$notification', style: const TextStyle(fontSize: 12, color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper for Chat/More Button
  Widget _chatOptionButton(IconData icon, String label, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
