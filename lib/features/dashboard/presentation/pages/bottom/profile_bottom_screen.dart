import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medilink/features/auth/presentation/pages/login_screen.dart';
import 'package:medilink/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:medilink/features/edit_profile/presentation/pages/edit_profile.dart';
import 'package:medilink/features/edit_profile/presentation/states/profile_state.dart';
import 'package:medilink/features/edit_profile/presentation/view_model/profile_view_model.dart';
import 'package:medilink/features/medical_records/presentation/view_model/medical_record_view_model.dart';
import 'package:medilink/features/settings/presentation/screens/settings_screen.dart';
import 'package:medilink/features/medical_records/presentation/pages/records_list_screen.dart';
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
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileViewModelProvider.notifier).loadProfile();
      ref
          .read(medicalRecordViewModelProvider.notifier)
          .fetchCurrentPatientRecords();
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

  String _reportTypeLabel(String type) {
    final value = type.toLowerCase();
    if (value.contains('pdf')) return 'PDF';
    if (value.contains('image') ||
        value.contains('jpg') ||
        value.contains('png') ||
        value.contains('jpeg')) {
      return 'Image';
    }
    return 'File';
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);
    final recordsState = ref.watch(medicalRecordViewModelProvider);
    final profile = profileState.profile;
    final recentReports = List.of(recordsState.records)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final latestReports = recentReports.take(3).toList();

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: Theme.of(context).brightness == Brightness.dark
                          ? const []
                          : const [
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
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
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
                              label: 'Gender',
                              value: profile?.gender ?? 'N/A',
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const InfoRow(
                        icon: Icons.warning_amber,
                        label: 'Allergies',
                        value: 'Not provided',
                      ),
                      const InfoRow(
                        icon: Icons.medical_information,
                        label: 'Chronic Illnesses',
                        value: 'Not provided',
                      ),
                      const InfoRow(
                        icon: Icons.person_add_alt,
                        label: 'Emergency Contact',
                        value: 'Not provided',
                      ),
                    ],
                  ),
                  MenuTile(
                    icon: Icons.description,
                    label: 'My Reports',
                    count: recordsState.records.length,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RecordsListScreen(),
                        ),
                      );
                    },
                  ),
                  MenuTile(
                    icon: Icons.calendar_today,
                    label: 'Prescriptions',
                    onTap: () {
                      Navigator.pushNamed(context, '/prescriptions');
                    },
                  ),
                  MenuTile(
                    icon: Icons.settings,
                    label: 'Settings',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  InfoCard(
                    title: 'Recent Reports',
                    trailing: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RecordsListScreen(),
                          ),
                        );
                      },
                      child: const Text('View All'),
                    ),
                    children: latestReports.isEmpty
                        ? const [
                            ListTile(
                              title: Text('No reports found'),
                              subtitle:
                                  Text('Your recent reports will appear here'),
                            ),
                          ]
                        : latestReports
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
                                title: Text(
                                    r.title.isNotEmpty ? r.title : 'Report'),
                                subtitle: Text(DateFormat('MMM dd, yyyy')
                                    .format(r.createdAt)),
                                trailing: Text(
                                  _reportTypeLabel(r.type),
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    tileColor: Theme.of(context).colorScheme.surface,
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
