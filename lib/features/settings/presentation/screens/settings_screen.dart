import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/app/theme/theme_mode_provider.dart';
import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/core/api/api_endpoints.dart';
import 'package:medilink/features/auth/presentation/pages/login_screen.dart';
import 'package:medilink/features/auth/presentation/view_model/auth_view_model.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _appointmentReminders = true;
  bool _biometricEnabled = false;
  bool _shareDataForResearch = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(appThemeModeProvider);
    final lightAutoMode = ref.watch(lightAutoModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSection(
            context,
            title: 'Account',
            icon: Icons.person_outline,
            items: [
              _SettingsTile(
                title: 'Profile',
                subtitle: 'Edit your profile information',
                icon: Icons.edit_outlined,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Profile editing available in Edit Profile')),
                  );
                },
              ),
              _SettingsTile(
                title: 'Change Password',
                subtitle: 'Update your password',
                icon: Icons.lock_outline,
                onTap: () => _showChangePasswordDialog(context),
              ),
              _SettingsTile(
                title: 'Biometric Login',
                subtitle: 'Use fingerprint or face recognition',
                icon: Icons.fingerprint,
                trailing: Switch(
                  value: _biometricEnabled,
                  onChanged: (value) {
                    setState(() {
                      _biometricEnabled = value;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(value
                            ? 'Biometric login enabled'
                            : 'Biometric login disabled'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            title: 'Notifications',
            icon: Icons.notifications_outlined,
            items: [
              _SettingsTile(
                title: 'Push Notifications',
                subtitle: 'Receive notifications on your device',
                icon: Icons.notifications_active_outlined,
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
              ),
              _SettingsTile(
                title: 'Email Notifications',
                subtitle: 'Receive updates via email',
                icon: Icons.email_outlined,
                trailing: Switch(
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                  },
                ),
              ),
              _SettingsTile(
                title: 'SMS Notifications',
                subtitle: 'Receive updates via SMS',
                icon: Icons.sms_outlined,
                trailing: Switch(
                  value: _smsNotifications,
                  onChanged: (value) {
                    setState(() {
                      _smsNotifications = value;
                    });
                  },
                ),
              ),
              _SettingsTile(
                title: 'Appointment Reminders',
                subtitle: 'Get reminded about upcoming appointments',
                icon: Icons.calendar_today_outlined,
                trailing: Switch(
                  value: _appointmentReminders,
                  onChanged: (value) {
                    setState(() {
                      _appointmentReminders = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            title: 'Appearance',
            icon: Icons.palette_outlined,
            items: [
              _SettingsTile(
                title: 'Dark Mode',
                subtitle: lightAutoMode.enabled
                    ? 'Controlled by light sensor'
                    : 'Switch to dark theme',
                icon: Icons.brightness_6_outlined,
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: lightAutoMode.enabled
                      ? null
                      : (value) => ref
                          .read(appThemeModeProvider.notifier)
                          .setDarkMode(value),
                ),
              ),
              _SettingsTile(
                title: 'Light Sensor Auto Mode',
                subtitle: lightAutoMode.enabled
                    ? (lightAutoMode.currentLux == null
                        ? 'Reading ambient light...'
                        : 'Auto-adjusting theme: ${lightAutoMode.currentLux!.toStringAsFixed(0)} lx')
                    : 'Auto-adjust theme based on ambient light',
                icon: Icons.wb_sunny_outlined,
                trailing: Switch(
                  value: lightAutoMode.enabled,
                  onChanged: (value) => ref
                      .read(lightAutoModeProvider.notifier)
                      .setEnabled(value),
                ),
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            title: 'Privacy & Security',
            icon: Icons.security_outlined,
            items: [
              _SettingsTile(
                title: 'Data Sharing',
                subtitle: 'Share data for medical research',
                icon: Icons.share_outlined,
                trailing: Switch(
                  value: _shareDataForResearch,
                  onChanged: (value) {
                    setState(() {
                      _shareDataForResearch = value;
                    });
                  },
                ),
              ),
              _SettingsTile(
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                icon: Icons.policy_outlined,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Privacy Policy coming soon')),
                  );
                },
              ),
              _SettingsTile(
                title: 'Terms of Service',
                subtitle: 'Read our terms of service',
                icon: Icons.description_outlined,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Terms of Service coming soon')),
                  );
                },
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            title: 'About',
            icon: Icons.info_outlined,
            items: [
              _SettingsTile(
                title: 'About MediLink',
                subtitle: 'Version 1.0.0',
                icon: Icons.info_outlined,
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'MediLink',
                    applicationVersion: '1.0.0',
                    applicationLegalese:
                        '© 2026 MediLink. All rights reserved.',
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                          'A comprehensive healthcare management application.'),
                    ],
                  );
                },
              ),
              _SettingsTile(
                title: 'Help & Support',
                subtitle: 'Get help with the app',
                icon: Icons.help_outline,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help & Support coming soon')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: OutlinedButton(
              onPressed: () => _showLogoutDialog(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
        ),
        ...items,
      ],
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _ChangePasswordDialog(ref: ref),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Log Out',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(authViewModelProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text(
              'Log Out',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _SettingsTile({
    required this.title,
    this.subtitle,
    required this.icon,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing:
          trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  final WidgetRef ref;

  const _ChangePasswordDialog({required this.ref});

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _oldPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  bool _isLoading = false;
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final apiClient = widget.ref.read(apiClientProvider);
      await apiClient.post(
        ApiEndpoints.changePassword,
        data: {
          'oldPassword': _oldPasswordController.text,
          'newPassword': _newPasswordController.text,
        },
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      String errorMessage = 'Failed to change password. Please try again.';

      if (e.toString().contains('404') ||
          e.toString().contains('Route not found')) {
        errorMessage =
            'Change password feature is not available yet. Please contact support.';
      } else if (e.toString().contains('401') ||
          e.toString().contains('incorrect')) {
        errorMessage = 'Current password is incorrect';
      } else if (e.toString().contains('400')) {
        errorMessage =
            'Invalid password format. Please try a stronger password.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        'Change Password',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: _obscureOldPassword,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureOldPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureOldPassword = !_obscureOldPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  if (value == _oldPasswordController.text) {
                    return 'New password must be different';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              const Text(
                'Password must be at least 8 characters long',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleChangePassword,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Change Password'),
        ),
      ],
    );
  }
}
