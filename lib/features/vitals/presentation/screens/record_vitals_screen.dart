import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:medilink/features/vitals/domain/entities/vitals_entity.dart';
import 'package:medilink/features/vitals/presentation/providers/vitals_providers.dart';

class RecordVitalsScreen extends ConsumerStatefulWidget {
  const RecordVitalsScreen({super.key});

  @override
  ConsumerState<RecordVitalsScreen> createState() => _RecordVitalsScreenState();
}

class _RecordVitalsScreenState extends ConsumerState<RecordVitalsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _vitalType = 'blood_pressure';
  final _valueController = TextEditingController();
  final _secondaryValueController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _recordedAt = DateTime.now();

  final List<Map<String, dynamic>> _vitalTypes = [
    {'value': 'blood_pressure', 'label': 'Blood Pressure', 'unit': 'mmHg', 'hasTwoValues': true},
    {'value': 'heart_rate', 'label': 'Heart Rate', 'unit': 'bpm', 'hasTwoValues': false},
    {'value': 'blood_sugar', 'label': 'Blood Sugar', 'unit': 'mg/dL', 'hasTwoValues': false},
    {'value': 'weight', 'label': 'Weight', 'unit': 'kg', 'hasTwoValues': false},
    {'value': 'temperature', 'label': 'Temperature', 'unit': '°C', 'hasTwoValues': false},
    {'value': 'oxygen', 'label': 'Oxygen Level', 'unit': '%', 'hasTwoValues': false},
  ];

  @override
  void dispose() {
    _valueController.dispose();
    _secondaryValueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Vitals'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              initialValue: _vitalType,
              decoration: const InputDecoration(
                labelText: 'Vital Type',
                border: OutlineInputBorder(),
              ),
              items: _vitalTypes.map((type) {
                return DropdownMenuItem(
                  value: type['value'] as String,
                  child: Text(type['label'] as String),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _vitalType = value!;
                  _valueController.clear();
                  _secondaryValueController.clear();
                });
              },
            ),
            const SizedBox(height: 16),
            if (_getCurrentType()['hasTwoValues'] as bool) ...[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _valueController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Systolic',
                        suffixText: _getCurrentType()['unit'] as String,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _secondaryValueController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Diastolic',
                        suffixText: _getCurrentType()['unit'] as String,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ] else
              TextFormField(
                controller: _valueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Value',
                  suffixText: _getCurrentType()['unit'] as String,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
              ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Recorded At'),
              subtitle: Text(
                '${_recordedAt.day}/${_recordedAt.month}/${_recordedAt.year} ${_recordedAt.hour}:${_recordedAt.minute.toString().padLeft(2, '0')}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDateTime(context),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _recordVital(context, authState.user?.authId ?? ''),
              child: const Text('Record Vital'),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getCurrentType() {
    return _vitalTypes.firstWhere((type) => type['value'] == _vitalType);
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _recordedAt,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_recordedAt),
      );

      if (time != null) {
        setState(() {
          _recordedAt = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _recordVital(BuildContext context, String patientId) async {
    if (!_formKey.currentState!.validate()) return;

    final vital = VitalsEntity(
      id: '',
      patientId: patientId,
      vitalType: _vitalType,
      value: double.parse(_valueController.text),
      secondaryValue: _secondaryValueController.text.isNotEmpty
          ? double.parse(_secondaryValueController.text)
          : null,
      unit: _getCurrentType()['unit'] as String,
      recordedAt: _recordedAt,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      createdAt: DateTime.now(),
    );

    final success = await ref.read(vitalsViewmodelProvider.notifier).recordVital(vital);

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vital recorded successfully')),
      );
      Navigator.pop(context);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to record vital')),
      );
    }
  }
}
