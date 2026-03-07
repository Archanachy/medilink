import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:medilink/features/prescriptions/presentation/viewmodel/prescription_viewmodel.dart';
import 'package:medilink/features/prescriptions/presentation/widgets/prescription_card.dart';

class PrescriptionsListScreen extends ConsumerStatefulWidget {
  const PrescriptionsListScreen({super.key});

  @override
  ConsumerState<PrescriptionsListScreen> createState() =>
      _PrescriptionsListScreenState();
}

class _PrescriptionsListScreenState
    extends ConsumerState<PrescriptionsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Delay provider modification until after widget tree is done building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPrescriptions();
    });
  }

  void _loadPrescriptions() {
    final session = ref.read(userSessionServiceProvider);
    final patientId =
        session.getCurrentPatientId() ?? session.getCurrentUserId();

    if (patientId != null && patientId.isNotEmpty) {
      ref
          .read(prescriptionViewModelProvider.notifier)
          .loadPrescriptions(patientId);
      return;
    }

    final user = ref.read(authViewModelProvider).user;
    if (user != null && user.authId != null) {
      ref
          .read(prescriptionViewModelProvider.notifier)
          .loadPrescriptions(user.authId!);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(prescriptionViewModelProvider);
    final viewModel = ref.read(prescriptionViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Prescriptions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'Expired'),
          ],
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? _buildErrorView(state.error!)
              : RefreshIndicator(
                  onRefresh: () async => _loadPrescriptions(),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPrescriptionList(viewModel.activePrescriptions),
                      _buildPrescriptionList(viewModel.completedPrescriptions),
                      _buildPrescriptionList(viewModel.expiredPrescriptions),
                    ],
                  ),
                ),
    );
  }

  Widget _buildPrescriptionList(List<PrescriptionEntity> prescriptions) {
    if (prescriptions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_information_outlined,
                size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No prescriptions found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: prescriptions.length,
      itemBuilder: (context, index) {
        return PrescriptionCard(
          prescription: prescriptions[index],
          onTap: () {
            Navigator.pushNamed(
              context,
              '/prescription-detail',
              arguments: prescriptions[index].id,
            );
          },
        );
      },
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            error,
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadPrescriptions,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
