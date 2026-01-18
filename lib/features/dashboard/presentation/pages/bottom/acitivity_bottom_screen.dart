import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/auth/presentation/pages/login_screen.dart';
import 'package:medilink/features/auth/presentation/view_model/auth_view_model.dart';

class ActivityBottomScreen extends ConsumerStatefulWidget {
  const ActivityBottomScreen({super.key});

  @override
  ConsumerState<ActivityBottomScreen> createState() => _ActivityBottomScreenState();
}

class _ActivityBottomScreenState extends ConsumerState<ActivityBottomScreen> {
  @override
  Widget build(BuildContext context) {
    final authContext = ref.watch(authViewModelProvider);
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
          const SizedBox(height: 24),
          // Container(
          //   icon: Icons.logout_rounded,
          //   title: 'Logout',
          //   iconColor: AppColors.error,
          //   titleColor: AppColors.error,
          //   onTap: () {
          //     _showLogoutDialog(context);
          //   },
          // ),
          // logout button add 
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                 _showLogoutDialog(context);
              },
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 18),
              ),
            ),
          )

        ],
      ),
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
        'Logout',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text(
            'Cancel',
            // style: TextStyle(color: context.textSecondary),
          ),
        ),
        TextButton(
          onPressed: () async {
              Navigator.pop(dialogContext);
              // Clear user session
              await ref.read(authViewModelProvider.notifier).logout();
              if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen())
              );
              }
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
  );
}
}

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         title: Text(
//           'Logout',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         content: Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(dialogContext),
//             child: Text(
//               'Cancel',
//               style: TextStyle(color: context.textSecondary),
//             ),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(dialogContext);
//               // Clear user session
//               await ref.read(authViewmodelProvider.notifier).logout();
//               if (context.mounted) {
//                 AppRoutes.pushAndRemoveUntil(context, const LoginPage());
//               }
//             },
//             child: Text(
//               'Logout',
//               style: TextStyle(
//                 color: AppColors.error,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// to use the above function inside the class
