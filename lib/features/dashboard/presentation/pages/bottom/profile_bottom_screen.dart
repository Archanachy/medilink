import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medilink/features/auth/presentation/pages/login_screen.dart';
import 'package:medilink/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:medilink/features/edit_profile/presentation/pages/edit_profile.dart';
import 'package:medilink/features/edit_profile/presentation/states/profile_state.dart';
import 'package:medilink/features/edit_profile/presentation/view_model/profile_view_model.dart';
import '../../widgets/info_card.dart';
import '../../widgets/info_row.dart';
import '../../widgets/menu_tile.dart';
import '../../widgets/mini_card.dart';
import '../../widgets/stat_item.dart';

class ProfileBottomScreen extends ConsumerStatefulWidget {
  const ProfileBottomScreen({super.key});

  @override
  ConsumerState<ProfileBottomScreen> createState() =>
      _ProfileBottomScreenState();
}

class _ProfileBottomScreenState extends ConsumerState<ProfileBottomScreen> {
  final medicalReports = [
    {'name': 'Blood Test Report', 'date': 'Jan 20, 2026', 'type': 'PDF'},
    {'name': 'X-Ray Chest', 'date': 'Jan 15, 2026', 'type': 'Image'},
    {'name': 'ECG Report', 'date': 'Dec 28, 2025', 'type': 'PDF'},
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileViewModelProvider.notifier).loadProfile();
    });
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Not provided';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _getInitials(String? firstName, String? lastName) {
    final first = firstName?.isNotEmpty == true ? firstName![0] : '';
    final last = lastName?.isNotEmpty == true ? lastName![0] : '';
    return (first + last).toUpperCase().isEmpty
        ? '?'
        : (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);
    final profile = profileState.profile;

    if (profileState.status == ProfileStatus.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (profileState.status == ProfileStatus.error) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(profileState.errorMessage ?? 'Failed to load profile'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(profileViewModelProvider.notifier).loadProfile();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 80),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfilePage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Profile Picture
                            profile?.profilePicture != null &&
                                    profile!.profilePicture!.isNotEmpty
                                ? CircleAvatar(
                                    radius: 40,
                                    backgroundImage: CachedNetworkImageProvider(
                                      profile.profilePicture!,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.blue,
                                    child: Text(
                                      _getInitials(profile?.firstName,
                                          profile?.lastName),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile?.fullName ?? 'User',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '@${profile?.userName ?? 'username'}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'Active',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            StatItem(value: '12', label: 'Appointments'),
                            StatItem(value: '3', label: 'Reports'),
                            StatItem(value: '8', label: 'Doctors'),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  InfoCard(
                    title: 'Personal Information',
                    children: [
                      InfoRow(
                        icon: Icons.person,
                        label: 'First Name',
                        value: profile?.firstName ?? 'Not provided',
                      ),
                      InfoRow(
                        icon: Icons.person_outline,
                        label: 'Last Name',
                        value: profile?.lastName ?? 'Not provided',
                      ),
                      InfoRow(
                        icon: Icons.email,
                        label: 'Email',
                        value: profile?.email ?? 'Not provided',
                      ),
                      InfoRow(
                        icon: Icons.phone,
                        label: 'Phone',
                        value: profile?.phoneNumber?.isNotEmpty == true
                            ? profile!.phoneNumber!
                            : 'Not provided',
                      ),
                      InfoRow(
                        icon: Icons.cake,
                        label: 'Date of Birth',
                        value: _formatDate(profile?.dateOfBirth),
                      ),
                      InfoRow(
                        icon: Icons.location_on,
                        label: 'Address',
                        value: profile?.address?.isNotEmpty == true
                            ? profile!.address!
                            : 'Not provided',
                      ),
                    ],
                  ),
                  InfoCard(
                    title: 'Medical Information',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: MiniCard(
                              label: 'Blood Group',
                              value: profile?.bloodGroup?.isNotEmpty == true
                                  ? profile!.bloodGroup!
                                  : 'N/A',
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MiniCard(
                              label: 'Username',
                              value: profile?.userName ?? 'N/A',
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const MenuTile(
                      icon: Icons.description, label: 'My Reports', count: 3),
                  const MenuTile(
                      icon: Icons.calendar_today, label: 'Medical History'),
                  const MenuTile(icon: Icons.settings, label: 'Settings'),
                  InfoCard(
                    title: 'Recent Reports',
                    trailing: TextButton(
                      onPressed: () {},
                      child: const Text('View All'),
                    ),
                    children: medicalReports
                        .map(
                          (r) => ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.description,
                                  color: Colors.blue),
                            ),
                            title: Text(r['name']!),
                            subtitle: Text(r['date']!),
                            trailing: Text(
                              r['type']!,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload New Report'),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () => _showLogoutDialog(context),
                  ),
                ],
              ),
            ),
          ],
        ),
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
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(authViewModelProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
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
