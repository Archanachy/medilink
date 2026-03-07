import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Terms of Service',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last updated: January 1, 2024',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: '1. Acceptance of Terms',
            content:
                'By accessing and using MediLink, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
          ),
          _buildSection(
            context,
            title: '2. Use License',
            content:
                'Permission is granted to temporarily access and use MediLink for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:\n\n• Modify or copy the materials\n• Use the materials for any commercial purpose\n• Attempt to decompile or reverse engineer any software\n• Remove any copyright or other proprietary notations',
          ),
          _buildSection(
            context,
            title: '3. Medical Disclaimer',
            content:
                'MediLink provides a platform for connecting patients with healthcare providers. The information provided through the platform is for informational purposes only and is not intended as a substitute for advice from your physician or other healthcare professional.',
          ),
          _buildSection(
            context,
            title: '4. User Accounts',
            content:
                'When you create an account with us, you must provide accurate, complete, and current information. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of your account.',
          ),
          _buildSection(
            context,
            title: '5. Privacy',
            content:
                'Your use of MediLink is also governed by our Privacy Policy. Please review our Privacy Policy, which also governs the platform and informs users of our data collection practices.',
          ),
          _buildSection(
            context,
            title: '6. Appointments and Consultations',
            content:
                'Appointments booked through MediLink are subject to availability and confirmation by the healthcare provider. MediLink is not responsible for the quality of medical services provided by healthcare professionals on the platform.',
          ),
          _buildSection(
            context,
            title: '7. Payment Terms',
            content:
                'All fees for services must be paid at the time of booking or as agreed between you and the healthcare provider. MediLink uses secure third-party payment processors for all transactions.',
          ),
          _buildSection(
            context,
            title: '8. Cancellation Policy',
            content:
                'Cancellation policies vary by healthcare provider. Please review the specific cancellation policy before booking an appointment. Some providers may charge cancellation fees.',
          ),
          _buildSection(
            context,
            title: '9. Limitation of Liability',
            content:
                'In no event shall MediLink or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use MediLink.',
          ),
          _buildSection(
            context,
            title: '10. Modifications',
            content:
                'MediLink reserves the right to revise these terms of service at any time without notice. By using this platform, you are agreeing to be bound by the then current version of these terms of service.',
          ),
          _buildSection(
            context,
            title: '11. Contact Information',
            content:
                'If you have any questions about these Terms, please contact us at:\n\nEmail: legal@medilink.com\nPhone: +1 (555) 123-4567\nAddress: 123 Healthcare Ave, Medical District, MD 12345',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
