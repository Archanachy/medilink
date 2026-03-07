import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:medilink/features/prescriptions/presentation/viewmodel/prescription_viewmodel.dart';

class CreatePrescriptionScreen extends ConsumerStatefulWidget {
  final String? patientId;
  final String? patientName;
  final String? doctorId;
  final String? doctorName;
  final String? appointmentId;

  const CreatePrescriptionScreen({
    super.key,
    this.patientId,
    this.patientName,
    this.doctorId,
    this.doctorName,
    this.appointmentId,
  });

  @override
  ConsumerState<CreatePrescriptionScreen> createState() =>
      _CreatePrescriptionScreenState();
}

class _CreatePrescriptionScreenState
    extends ConsumerState<CreatePrescriptionScreen> {
  late TextEditingController _patientIdController;
  late TextEditingController _patientNameController;
  late TextEditingController _diagnosisController;
  late TextEditingController _notesController;
  late TextEditingController _doctorIdController;
  late TextEditingController _doctorNameController;
  late TextEditingController _appointmentIdController;

  final List<_MedicationForm> _medications = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _patientIdController = TextEditingController(text: widget.patientId ?? '');
    _patientNameController =
        TextEditingController(text: widget.patientName ?? '');
    _diagnosisController = TextEditingController();
    _notesController = TextEditingController();

    final session = ref.read(userSessionServiceProvider);
    final sessionDoctorId = session.getCurrentUserId() ?? '';
    final sessionDoctorName = session.getCurrentUserFullName() ?? '';

    _doctorIdController = TextEditingController(
      text: widget.doctorId ?? sessionDoctorId,
    );
    _doctorNameController = TextEditingController(
      text: widget.doctorName ?? sessionDoctorName,
    );
    _appointmentIdController = TextEditingController(
      text: widget.appointmentId ?? '',
    );

    if (widget.appointmentId != null && widget.appointmentId!.isNotEmpty) {
      _notesController.text = 'Linked appointment: ${widget.appointmentId}';
    }
  }

  @override
  void dispose() {
    _patientIdController.dispose();
    _patientNameController.dispose();
    _diagnosisController.dispose();
    _notesController.dispose();
    _doctorIdController.dispose();
    _doctorNameController.dispose();
    _appointmentIdController.dispose();
    for (final med in _medications) {
      med.dispose();
    }
    super.dispose();
  }

  void _addMedication() {
    setState(() {
      _medications.add(_MedicationForm());
    });
  }

  void _removeMedication(int index) {
    setState(() {
      _medications[index].dispose();
      _medications.removeAt(index);
    });
  }

  Future<void> _submitPrescription() async {
    if (_patientIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a patient')),
      );
      return;
    }

    if (_medications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one medication')),
      );
      return;
    }

    // Validate all medications
    for (int i = 0; i < _medications.length; i++) {
      final med = _medications[i];
      if (med.nameController.text.isEmpty ||
          med.dosageController.text.isEmpty ||
          med.frequencyController.text.isEmpty ||
          med.durationController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please complete medication ${i + 1}')),
        );
        return;
      }
    }

    setState(() => _isSubmitting = true);

    try {
      final medications = _medications
          .map((m) => Medication(
                name: m.nameController.text,
                dosage: m.dosageController.text,
                frequency: m.frequencyController.text,
                duration: m.durationController.text,
                instructions: m.instructionsController.text.isEmpty
                    ? null
                    : m.instructionsController.text,
              ))
          .toList();

      final prescription = PrescriptionEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        patientId: _patientIdController.text,
        doctorId: _doctorIdController.text,
        doctorName: _doctorNameController.text,
        appointmentId: widget.appointmentId,
        medications: medications,
        diagnosis: _diagnosisController.text.isEmpty
            ? null
            : _diagnosisController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        date: DateTime.now(),
        status: 'active',
      );

      final success = await ref
          .read(prescriptionViewModelProvider.notifier)
          .createPrescription(prescription);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Prescription issued successfully')),
          );
          Navigator.pop(context, true);
        } else {
          final error = ref.read(prescriptionViewModelProvider).createError;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error ?? 'Failed to create prescription')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(prescriptionViewModelProvider).isCreating;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Issue Prescription'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Selection Section
                _buildSection(
                  'Patient Information',
                  [
                    TextField(
                      controller: _patientIdController,
                      decoration: InputDecoration(
                        labelText: 'Patient ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Enter or search patient ID',
                      ),
                      readOnly: widget.patientId != null,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _patientNameController,
                      decoration: InputDecoration(
                        labelText: 'Patient Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Auto-filled from ID',
                      ),
                      readOnly: true,
                    ),
                    if (widget.appointmentId != null &&
                        widget.appointmentId!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _appointmentIdController,
                        decoration: InputDecoration(
                          labelText: 'Appointment ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        readOnly: true,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 24),

                // Doctor Info Section
                _buildSection(
                  'Doctor Information',
                  [
                    TextField(
                      controller: _doctorIdController,
                      decoration: InputDecoration(
                        labelText: 'Doctor ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Auto-filled from login',
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _doctorNameController,
                      decoration: InputDecoration(
                        labelText: 'Doctor Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Auto-filled from login',
                      ),
                      readOnly: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Diagnosis Section
                _buildSection(
                  'Medical Information',
                  [
                    TextField(
                      controller: _diagnosisController,
                      decoration: InputDecoration(
                        labelText: 'Diagnosis',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Chief complaint and diagnosis',
                      ),
                      minLines: 2,
                      maxLines: 4,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Medications Section
                _buildMedicationsSection(),
                const SizedBox(height: 24),

                // Additional Notes
                _buildSection(
                  'Additional Notes',
                  [
                    TextField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: 'Special Instructions',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Any special instructions for the patient',
                      ),
                      minLines: 2,
                      maxLines: 4,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        _isSubmitting || isLoading ? null : _submitPrescription,
                    child: _isSubmitting || isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Issue Prescription'),
                  ),
                ),
                const SizedBox(height: 16),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: _isSubmitting || isLoading
                        ? null
                        : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildMedicationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Medications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _addMedication,
              icon: const Icon(Icons.add),
              label: const Text('Add Medication'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_medications.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('No medications added yet'),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _medications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _MedicationCard(
                medication: _medications[index],
                index: index,
                onRemove: () => _removeMedication(index),
              );
            },
          ),
      ],
    );
  }
}

class _MedicationForm {
  late TextEditingController nameController;
  late TextEditingController dosageController;
  late TextEditingController frequencyController;
  late TextEditingController durationController;
  late TextEditingController instructionsController;

  _MedicationForm() {
    nameController = TextEditingController();
    dosageController = TextEditingController();
    frequencyController = TextEditingController();
    durationController = TextEditingController();
    instructionsController = TextEditingController();
  }

  void dispose() {
    nameController.dispose();
    dosageController.dispose();
    frequencyController.dispose();
    durationController.dispose();
    instructionsController.dispose();
  }
}

class _MedicationCard extends StatelessWidget {
  final _MedicationForm medication;
  final int index;
  final VoidCallback onRemove;

  const _MedicationCard({
    required this.medication,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Medication ${index + 1}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: onRemove,
                  tooltip: 'Remove medication',
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: medication.nameController,
              decoration: InputDecoration(
                labelText: 'Medication Name *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'e.g., Paracetamol',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: medication.dosageController,
                    decoration: InputDecoration(
                      labelText: 'Dosage *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'e.g., 500mg',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: medication.frequencyController,
                    decoration: InputDecoration(
                      labelText: 'Frequency *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'e.g., Twice daily',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: medication.durationController,
              decoration: InputDecoration(
                labelText: 'Duration *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'e.g., 7 days',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: medication.instructionsController,
              decoration: InputDecoration(
                labelText: 'Special Instructions',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'e.g., Take after meals',
              ),
              minLines: 1,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
