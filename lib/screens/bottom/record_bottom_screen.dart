import 'package:flutter/material.dart';

class RecordBottomScreen extends StatelessWidget {
  const RecordBottomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description,
            size: isTablet ? 100 : 70,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            "Medical Records",
            style: TextStyle(
              fontSize: isTablet ? 26 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "View your medical history",
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
