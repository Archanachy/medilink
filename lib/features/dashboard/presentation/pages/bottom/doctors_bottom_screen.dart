import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/doctors/presentation/states/doctor_state.dart';
import 'package:medilink/features/doctors/presentation/view_model/doctor_view_model.dart';

class DoctorsBottomScreen extends ConsumerStatefulWidget {
  const DoctorsBottomScreen({super.key});

  @override
  ConsumerState<DoctorsBottomScreen> createState() =>
      _DoctorsBottomScreenState();
}

class _DoctorsBottomScreenState extends ConsumerState<DoctorsBottomScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(doctorViewModelProvider.notifier).fetchDoctors();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doctorState = ref.watch(doctorViewModelProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: _buildBody(doctorState),
      ),
    );
  }

  Widget _buildBody(DoctorState state) {
    // Loading state
    if (state.status == DoctorStatus.loading && state.doctors.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading doctors...'),
          ],
        ),
      );
    }

    // Error state
    if (state.status == DoctorStatus.error && state.doctors.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                state.errorMessage ?? 'Failed to load doctors',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(doctorViewModelProvider.notifier).fetchDoctors();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Success state
    return Column(
      children: [
        // Header and Search
        Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Find Doctors',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  ref.read(doctorViewModelProvider.notifier).fetchDoctors(
                        searchQuery: value.isNotEmpty ? value : null,
                      );
                },
                decoration: InputDecoration(
                  hintText: 'Search by name or specialization',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ],
          ),
        ),

        // Doctors List
        Expanded(
          child: state.doctors.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person_search,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No doctors found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(doctorViewModelProvider.notifier)
                        .fetchDoctors();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = state.doctors[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: Theme.of(context).colorScheme.surface,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/doctor-detail',
                              arguments: doctor.id,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Doctor Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: doctor.profilePicture != null &&
                                          doctor.profilePicture!.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: doctor.profilePicture!,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            width: 80,
                                            height: 80,
                                            color: Colors.blue.shade100,
                                            child: const Icon(Icons.person),
                                          ),
                                        )
                                      : Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.blue.shade100,
                                          child: const Icon(Icons.person),
                                        ),
                                ),
                                const SizedBox(width: 12),

                                // Doctor Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Dr. ${doctor.firstName} ${doctor.lastName}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        doctor.specialization,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue[600],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/book-appointment',
                                            arguments: doctor.id,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                        ),
                                        child: const Text('Book Appointment'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
