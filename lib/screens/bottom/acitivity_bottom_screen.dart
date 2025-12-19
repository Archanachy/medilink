import 'package:flutter/material.dart';

class ActivityBottomScreen extends StatelessWidget {
  const ActivityBottomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: isTablet ? 100 : 70,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            "Activity",
            style: TextStyle(
              fontSize: isTablet ? 26 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Recent activity will appear here",
            style: TextStyle(
              fontSize: isTablet ? 18 : 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
