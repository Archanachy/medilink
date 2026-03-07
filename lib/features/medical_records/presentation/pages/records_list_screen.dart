import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/medical_records/presentation/states/medical_record_state.dart';
import 'package:medilink/features/medical_records/presentation/view_model/medical_record_view_model.dart';
import 'package:medilink/features/medical_records/presentation/widgets/record_card_widget.dart';

class RecordsListScreen extends ConsumerStatefulWidget {
  const RecordsListScreen({super.key});

  @override
  ConsumerState<RecordsListScreen> createState() => _RecordsListScreenState();
}

class _RecordsListScreenState extends ConsumerState<RecordsListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(medicalRecordViewModelProvider.notifier)
          .fetchCurrentPatientRecords();
    });
  }

  void _loadRecords() {
    ref
        .read(medicalRecordViewModelProvider.notifier)
        .fetchCurrentPatientRecords();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(medicalRecordViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Records'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/upload-record'),
            icon: const Icon(Icons.upload_file),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loadRecords,
                child: const Text('Refresh Records'),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (state.status == MedicalRecordStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == MedicalRecordStatus.error) {
                    return Center(
                      child:
                          Text(state.errorMessage ?? 'Failed to load records'),
                    );
                  }
                  if (state.records.isEmpty) {
                    return const Center(child: Text('No records found'));
                  }
                  return ListView.builder(
                    itemCount: state.records.length,
                    itemBuilder: (context, index) {
                      final record = state.records[index];
                      return RecordCardWidget(
                        record: record,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/record-detail',
                            arguments: record.id,
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
