import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/config/environment.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/medical_records/presentation/states/medical_record_state.dart';
import 'package:medilink/features/medical_records/presentation/view_model/medical_record_view_model.dart';
import 'package:medilink/features/medical_records/presentation/widgets/pdf_viewer_widget.dart';
import 'package:medilink/features/prescriptions/presentation/state/prescription_state.dart';
import 'package:medilink/features/prescriptions/presentation/viewmodel/prescription_viewmodel.dart';

class RecordDetailScreen extends ConsumerStatefulWidget {
  final String recordId;

  const RecordDetailScreen({
    super.key,
    required this.recordId,
  });

  @override
  ConsumerState<RecordDetailScreen> createState() => _RecordDetailScreenState();
}

class _RecordDetailScreenState extends ConsumerState<RecordDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(medicalRecordViewModelProvider.notifier)
          .selectRecord(widget.recordId);
      _loadPrescriptionsForCurrentPatient();
    });
  }

  void _loadPrescriptionsForCurrentPatient() {
    final session = ref.read(userSessionServiceProvider);
    final patientId =
        session.getCurrentPatientId() ?? session.getCurrentUserId();

    if (patientId != null && patientId.isNotEmpty) {
      ref
          .read(prescriptionViewModelProvider.notifier)
          .loadPrescriptions(patientId);
    }
  }

  String _buildFullUrl(String fileUrl) {
    if (fileUrl.startsWith('http://') || fileUrl.startsWith('https://')) {
      return fileUrl;
    }

    // Handle incorrect legacy paths from test data
    String correctedPath = fileUrl;
    if (fileUrl.startsWith('/reports/')) {
      // Convert old /reports/ paths to correct /uploads/medical-reports/ paths
      correctedPath =
          fileUrl.replaceFirst('/reports/', '/uploads/medical-reports/');
    } else if (!fileUrl.startsWith('/uploads/')) {
      // If it doesn't start with /uploads/, assume it needs to be prefixed
      correctedPath = '/uploads/medical-reports/$fileUrl';
    }

    // Remove leading slash if present to avoid double slashes
    final path = correctedPath.startsWith('/')
        ? correctedPath.substring(1)
        : correctedPath;
    return '${Environment.baseUrl}/$path';
  }

  Widget _buildPrescriptionsSection(
    BuildContext context,
    PrescriptionState prescriptionState,
  ) {
    if (prescriptionState.isLoading) {
      return Row(
        children: const [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text('Loading prescriptions...'),
        ],
      );
    }

    if (prescriptionState.error != null &&
        prescriptionState.error!.isNotEmpty) {
      return Row(
        children: [
          const Icon(Icons.error_outline, size: 18, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Prescriptions unavailable',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          TextButton(
            onPressed: _loadPrescriptionsForCurrentPatient,
            child: const Text('Retry'),
          ),
        ],
      );
    }

    if (prescriptionState.prescriptions.isEmpty) {
      return Text(
        'No prescriptions available for this patient.',
        style: TextStyle(color: Colors.grey.shade700),
      );
    }

    final sortedPrescriptions = [...prescriptionState.prescriptions]
      ..sort((a, b) => b.date.compareTo(a.date));
    final previewItems = sortedPrescriptions.take(2).toList();

    return Column(
      children: [
        ...previewItems.map(
          (prescription) {
            final medicationSummary = prescription.medications.isNotEmpty
                ? prescription.medications
                    .take(2)
                    .map((m) => '${m.name} (${m.dosage})')
                    .join(', ')
                : 'No medication details';

            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          prescription.doctorName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: prescription.status.toLowerCase() == 'active'
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          prescription.status,
                          style: TextStyle(
                            fontSize: 11,
                            color: prescription.status.toLowerCase() == 'active'
                                ? Colors.green.shade800
                                : Colors.orange.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    medicationSummary,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => Navigator.pushNamed(context, '/prescriptions'),
            child: const Text('View all prescriptions'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(medicalRecordViewModelProvider);
    final prescriptionState = ref.watch(prescriptionViewModelProvider);
    final record = state.selectedRecord;

    return Scaffold(
      appBar: AppBar(title: const Text('Record Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Builder(
          builder: (context) {
            if (state.status == MedicalRecordStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == MedicalRecordStatus.error) {
              return Center(
                child: Text(state.errorMessage ?? 'Failed to load record'),
              );
            }
            if (record == null) {
              return const Center(child: Text('Record not found'));
            }

            final isPdf = record.fileUrl.toLowerCase().endsWith('.pdf');
            final fullImageUrl = _buildFullUrl(record.fileUrl);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Type: ${record.type}'),
                const SizedBox(height: 8),
                Text(
                    'Created: ${record.createdAt.toLocal().toString().split(' ')[0]}'),
                if (record.notes != null && record.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Notes: ${record.notes}'),
                ],
                const SizedBox(height: 12),
                const Text(
                  'Prescriptions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                _buildPrescriptionsSection(context, prescriptionState),
                const SizedBox(height: 16),
                Expanded(
                  child: isPdf
                      ? PdfViewerWidget(url: fullImageUrl)
                      : CachedNetworkImage(
                          imageUrl: fullImageUrl,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.broken_image,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Unable to load image',
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'URL: $fullImageUrl',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
