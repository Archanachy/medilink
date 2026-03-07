import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Privacy Policy',
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
            title: '1. Introduction',
            content:
                'Welcome to MediLink. We respect your privacy and are committed to protecting your personal data. This privacy policy will inform you about how we look after your personal data and tell you about your privacy rights.',
          ),
          _buildSection(
            context,
            title: '2. Data We Collect',
            content:
                'We may collect, use, store and transfer different kinds of personal data about you:\n\n• Identity Data: name, username, date of birth\n• Contact Data: email address, phone number, address\n• Health Data: medical records, prescriptions, consultation notes\n• Transaction Data: payment information, appointment history\n• Technical Data: IP address, browser type, device information\n• Usage Data: how you use our platform',
          ),
          _buildSection(
            context,
            title: '3. How We Use Your Data',
            content:
                'We use your personal data for the following purposes:\n\n• To provide healthcare services and manage appointments\n• To process payments and transaction records\n• To send appointment reminders and notifications\n• To improve our platform and user experience\n• To comply with legal and regulatory requirements\n• To protect against fraud and unauthorized access',
          ),
          _buildSection(
            context,
            title: '4. Data Security',
            content:
                'We have implemented appropriate security measures to prevent your personal data from being accidentally lost, used, accessed, altered, or disclosed in an unauthorized way. All health data is encrypted both in transit and at rest using industry-standard encryption protocols.',
          ),
          _buildSection(
            context,
            title: '5. Data Sharing',
            content:
                'We may share your personal data with:\n\n• Healthcare providers you book appointments with\n• Payment processors for transaction handling\n• Cloud service providers for data storage\n• Legal authorities when required by law\n\nWe do not sell your personal data to third parties.',
          ),
          _buildSection(
            context,
            title: '6. HIPAA Compliance',
            content:
                'MediLink is committed to compliance with the Health Insurance Portability and Accountability Act (HIPAA). We implement administrative, physical, and technical safeguards to protect your protected health information (PHI).',
          ),
          _buildSection(
            context,
            title: '7. Your Rights',
            content:
                'Under data protection laws, you have rights including:\n\n• Right to access your personal data\n• Right to correct inaccurate data\n• Right to request deletion of your data\n• Right to restrict processing of your data\n• Right to data portability\n• Right to object to processing\n• Right to withdraw consent',
          ),
          _buildSection(
            context,
            title: '8. Data Retention',
            content:
                'We will retain your personal data only for as long as necessary to fulfill the purposes we collected it for, including for the purposes of satisfying any legal, accounting, or reporting requirements. Medical records may be retained for longer periods as required by law.',
          ),
          _buildSection(
            context,
            title: '9. Cookies',
            content:
                'We use cookies and similar tracking technologies to track activity on our platform and hold certain information. You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent.',
          ),
          _buildSection(
            context,
            title: '10. Children\'s Privacy',
            content:
                'MediLink is not intended for use by children under the age of 13. We do not knowingly collect personal data from children under 13. If you are a parent or guardian and believe your child has provided us with personal data, please contact us.',
          ),
          _buildSection(
            context,
            title: '11. International Transfers',
            content:
                'Your personal data may be transferred to and processed in countries other than your own. We ensure that appropriate safeguards are in place to protect your data in accordance with this privacy policy.',
          ),
          _buildSection(
            context,
            title: '12. Changes to This Policy',
            content:
                'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date.',
          ),
          _buildSection(
            context,
            title: '13. Contact Us',
            content:
                'If you have any questions about this Privacy Policy or our data practices, please contact us:\n\nEmail: privacy@medilink.com\nPhone: +1 (555) 123-4567\nAddress: 123 Healthcare Ave, Medical District, MD 12345\n\nData Protection Officer: dpo@medilink.com',
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
