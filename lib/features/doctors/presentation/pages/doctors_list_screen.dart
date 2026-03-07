import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/doctors/presentation/states/doctor_state.dart';
import 'package:medilink/features/doctors/presentation/view_model/doctor_view_model.dart';
import 'package:medilink/features/doctors/presentation/widgets/doctor_card.dart';
import 'package:medilink/features/doctors/presentation/widgets/doctor_filter.dart';

class DoctorsListScreen extends ConsumerStatefulWidget {
  const DoctorsListScreen({super.key});

  @override
  ConsumerState<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends ConsumerState<DoctorsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();

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
    _specializationController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    ref.read(doctorViewModelProvider.notifier).updateFilters(
          searchQuery: _searchController.text.trim(),
          specialization: _specializationController.text.trim(),
        );
  }

  void _clearFilters() {
    _searchController.clear();
    _specializationController.clear();
    ref.read(doctorViewModelProvider.notifier).updateFilters(
          searchQuery: '',
          specialization: '',
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(doctorViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DoctorFilterWidget(
              specializationController: _specializationController,
              searchController: _searchController,
              onApply: _applyFilters,
              onClear: _clearFilters,
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (state.status == DoctorStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == DoctorStatus.error) {
                    return Center(
                      child: Text(state.errorMessage ?? 'Failed to load doctors'),
                    );
                  }
                  if (state.doctors.isEmpty) {
                    return const Center(child: Text('No doctors found'));
                  }
                  return ListView.builder(
                    itemCount: state.doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = state.doctors[index];
                      return DoctorCard(
                        doctor: doctor,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/doctor-detail',
                            arguments: doctor.id,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
