import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medilink/features/dashboard/presentation/states/dashboard_state.dart';
import 'package:medilink/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:medilink/features/dashboard/presentation/widgets/health_tip_card.dart';

class HomeBottomScreen extends ConsumerStatefulWidget {
  const HomeBottomScreen({super.key});

  @override
  ConsumerState<HomeBottomScreen> createState() => _HomeBottomScreenState();
}

class _HomeBottomScreenState extends ConsumerState<HomeBottomScreen> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardViewModelProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardViewModelProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: _buildBody(dashboardState),
      ),
    );
  }

  Widget _buildBody(DashboardState state) {
    // Loading state
    if (state.status == DashboardStatus.loading && !state.hasData) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading dashboard...'),
          ],
        ),
      );
    }

    // Error state
    if (state.hasError && !state.hasData) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                state.errorMessage ?? 'Failed to load dashboard',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ref
                      .read(dashboardViewModelProvider.notifier)
                      .loadDashboardData();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Success state with data
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(dashboardViewModelProvider.notifier).refresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info
            _buildHeader(state),
            const SizedBox(height: 20),

            // Quick Stats Bar
            _buildQuickStats(state),
            const SizedBox(height: 20),

            // Show error banner if refreshing failed
            if (state.hasError && state.hasData) _buildErrorBanner(state),

            // Appointment Card
            _buildAppointmentSection(state),
            const SizedBox(height: 20),

            // Quick Actions Grid
            _buildQuickActionsGrid(state),
            const SizedBox(height: 20),

            // Recent Records Section
            if (state.recentRecords.isNotEmpty)
              _buildRecentRecordsSection(state),

            const SizedBox(height: 20),

            // Health Tips Carousel
            _buildHealthTipsCarousel(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(DashboardState state) {
    final user = state.user;
    final firstName = user?.firstName ?? 'User';
    final profilePicture = user?.profilePicture;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // User Avatar
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.blue.shade100,
              backgroundImage:
                  profilePicture != null && profilePicture.isNotEmpty
                      ? CachedNetworkImageProvider(profilePicture)
                      : null,
              child: profilePicture == null || profilePicture.isEmpty
                  ? Text(
                      firstName[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $firstName',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (state.lastUpdated != null)
                  Text(
                    'Updated: ${_formatTimeAgo(state.lastUpdated!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ],
        ),
        // Notification Icon with Badge
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, size: 28),
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            if (state.unreadNotifications > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${state.unreadNotifications > 9 ? '9+' : state.unreadNotifications}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickStats(DashboardState state) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.calendar_today,
            count: state.upcomingAppointments.length.toString(),
            label: 'Appointments',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.folder_outlined,
            count: state.recentRecords.length.toString(),
            label: 'Records',
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: _StatCard(
            icon: Icons.medication,
            count: '0',
            label: 'Prescriptions',
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner(DashboardState state) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              state.errorMessage ?? 'Failed to refresh data',
              style: TextStyle(color: Colors.red.shade900, fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(dashboardViewModelProvider.notifier).clearError();
            },
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentSection(DashboardState state) {
    if (state.upcomingAppointments.isEmpty) {
      return _buildNoAppointmentsCard();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: _cardShadows(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Appointments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (state.upcomingAppointments.length > 5)
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/appointments'),
                  child: const Text('View All →'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.upcomingAppointments.length > 5
                ? 5
                : state.upcomingAppointments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final appointment = state.upcomingAppointments[index];
              return _buildAppointmentRow(appointment);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentRow(dynamic appointment) {
    final doctorName = appointment.doctorName ?? 'Doctor';
    final doctorInitials = doctorName.isNotEmpty
        ? doctorName.split(' ').map((e) => e[0]).join().toUpperCase()
        : 'D';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(
          context,
          '/appointment-detail',
          arguments: appointment.id,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Doctor Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  doctorInitials,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Doctor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      appointment.doctorSpecialization ?? 'General Practice',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Date & Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatAppointmentDate(appointment.appointmentDate),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    appointment.startTime ?? '--:--',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoAppointmentsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: _cardShadows(context),
      ),
      child: Column(
        children: [
          Icon(Icons.calendar_today_outlined,
              size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            'No Upcoming Appointments',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Book an appointment with a doctor',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/book-appointment');
            },
            icon: const Icon(Icons.add),
            label: const Text('Book Appointment'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(DashboardState state) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _cardShadows(context),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.95,
            ),
            children: [
              _ActionButton(
                icon: Icons.search,
                label: 'Find Doctor',
                onTap: () => Navigator.pushNamed(context, '/doctors'),
              ),
              _ActionButton(
                icon: Icons.calendar_month,
                label: 'Book Appointment',
                onTap: () => Navigator.pushNamed(context, '/book-appointment'),
              ),
              _ActionButton(
                icon: Icons.chat_bubble_outline,
                label: 'Messages',
                onTap: () => Navigator.pushNamed(context, '/conversations'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRecordsSection(DashboardState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Medical Records',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/records');
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...state.recentRecords.take(3).map((record) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: _cardShadows(context),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getRecordIcon(record.type),
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatRecordDate(record.createdAt),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildHealthTipsCarousel() {
    // Sample health tips - in future this will load from API
    final healthTips = [
      {
        'title': 'Stay Hydrated',
        'description':
            'Drink at least 8 glasses of water daily for optimal health.',
      },
      {
        'title': 'Regular Exercise',
        'description':
            'Exercise 30 minutes a day to keep your body fit and healthy.',
      },
      {
        'title': 'Balanced Diet',
        'description':
            'Eat a variety of fruits, vegetables, and whole grains daily.',
      },
      {
        'title': 'Quality Sleep',
        'description': 'Get 7-8 hours of sleep each night for better health.',
      },
      {
        'title': 'Mental Health',
        'description': 'Take time for meditation and stress management daily.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Health Tips',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/health-tips');
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: healthTips.length,
            itemBuilder: (context, index) {
              final tip = healthTips[index];
              return HealthTipCard(
                title: tip['title'] ?? '',
                description: tip['description'] ?? '',
                onTap: () {
                  Navigator.pushNamed(context, '/health-tips');
                },
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM dd, HH:mm').format(dateTime);
    }
  }

  String _formatAppointmentDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final appointmentDay = DateTime(date.year, date.month, date.day);

    String dayText;
    if (appointmentDay == today) {
      dayText = 'Today';
    } else if (appointmentDay == tomorrow) {
      dayText = 'Tomorrow';
    } else {
      dayText = DateFormat('MMM dd').format(date);
    }

    final timeText = DateFormat('HH:mm').format(date);
    return '$dayText at $timeText';
  }

  String _formatRecordDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  IconData _getRecordIcon(String type) {
    switch (type.toLowerCase()) {
      case 'lab':
      case 'test':
        return Icons.science;
      case 'prescription':
        return Icons.medication;
      case 'scan':
      case 'xray':
      case 'imaging':
        return Icons.image;
      case 'report':
        return Icons.description;
      default:
        return Icons.file_present;
    }
  }

  List<BoxShadow> _cardShadows(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const []
        : const [BoxShadow(blurRadius: 8, color: Colors.black12)];
  }
}

// Quick Action Button
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDark
              ? const []
              : const [BoxShadow(blurRadius: 8, color: Colors.black12)],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: colorScheme.onSurface),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String count;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? const []
            : const [BoxShadow(blurRadius: 4, color: Colors.black12)],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
