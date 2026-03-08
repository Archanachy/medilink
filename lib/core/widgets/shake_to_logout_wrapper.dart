import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/app/navigation/app_navigator.dart';
import 'package:medilink/core/services/shake/shake_detector_service.dart';
import 'package:medilink/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:medilink/features/auth/presentation/pages/login_screen.dart';

class ShakeToLogoutWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const ShakeToLogoutWrapper({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<ShakeToLogoutWrapper> createState() =>
      _ShakeToLogoutWrapperState();
}

class _ShakeToLogoutWrapperState extends ConsumerState<ShakeToLogoutWrapper> {
  final ShakeDetectorService _shakeService = ShakeDetectorService();

  @override
  void initState() {
    super.initState();
    _shakeService.initialize(
      onShakeThresholdReached: _showLogoutDialog,
    );
  }

  void _showLogoutDialog() {
    // Ensure dialog is only shown once
    final navigatorContext = AppNavigator.key.currentContext;
    if (_shakeService.isDialogShowing && navigatorContext != null) {
      showDialog(
        context: navigatorContext,
        barrierDismissible: true,
        builder: (dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: const [
              Icon(Icons.vibration, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Shake detected! Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _shakeService.resetDialogFlag();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                _shakeService.resetDialogFlag();
                
                await ref.read(authViewModelProvider.notifier).logout();
                
                AppNavigator.key.currentState?.pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ).then((_) {
        // Reset flag when dialog is dismissed
        _shakeService.resetDialogFlag();
      });
    }
  }

  @override
  void dispose() {
    _shakeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
