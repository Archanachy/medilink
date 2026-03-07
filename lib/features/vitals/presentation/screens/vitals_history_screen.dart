import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medilink/features/vitals/presentation/providers/vitals_providers.dart';
import 'package:medilink/features/vitals/presentation/state/vitals_state.dart';
import 'package:medilink/features/vitals/presentation/widgets/vitals_chart_widget.dart';

class VitalsHistoryScreen extends ConsumerStatefulWidget {
  const VitalsHistoryScreen({super.key});

  @override
  ConsumerState<VitalsHistoryScreen> createState() => _VitalsHistoryScreenState();
}

class _VitalsHistoryScreenState extends ConsumerState<VitalsHistoryScreen> {
  String? _selectedVitalType;

  final List<Map<String, dynamic>> _vitalTypes = [
    {'type': null, 'label': 'All', 'icon': Icons.timeline},
    {'type': 'blood_pressure', 'label': 'Blood Pressure', 'icon': Icons.favorite},
    {'type': 'heart_rate', 'label': 'Heart Rate', 'icon': Icons.monitor_heart},
    {'type': 'blood_sugar', 'label': 'Blood Sugar', 'icon': Icons.water_drop},
    {'type': 'weight', 'label': 'Weight', 'icon': Icons.monitor_weight},
    {'type': 'temperature', 'label': 'Temperature', 'icon': Icons.thermostat},
    {'type': 'oxygen', 'label': 'Oxygen Level', 'icon': Icons.air},
  ];

  @override
  Widget build(BuildContext context) {
    final vitalsState = ref.watch(vitalsViewmodelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Vitals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showVitalTypeFilter(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildVitalTypeChips(),
          if (vitalsState.status == VitalsStatus.loading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (vitalsState.vitals.isEmpty)
            const Expanded(
              child: Center(child: Text('No vitals recorded yet')),
            )
          else
            Expanded(
              child: ListView(
                children: [
                  if (_selectedVitalType != null)
                    VitalsChartWidget(
                      vitals: vitalsState.getVitalsByType(_selectedVitalType!),
                      vitalType: _selectedVitalType!,
                    ),
                  _buildVitalsList(vitalsState),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/vitals/record'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildVitalTypeChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: _vitalTypes.map((vitalType) {
          final isSelected = _selectedVitalType == vitalType['type'];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                children: [
                  Icon(
                    vitalType['icon'] as IconData,
                    size: 18,
                    color: isSelected ? Colors.white : null,
                  ),
                  const SizedBox(width: 4),
                  Text(vitalType['label'] as String),
                ],
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedVitalType = selected ? (vitalType['type'] as String?) : null;
                });
                ref
                    .read(vitalsViewmodelProvider.notifier)
                    .setVitalType(_selectedVitalType);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVitalsList(VitalsState vitalsState) {
    final displayVitals = _selectedVitalType == null
        ? vitalsState.vitals
        : vitalsState.getVitalsByType(_selectedVitalType!);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: displayVitals.length,
      itemBuilder: (context, index) {
        final vital = displayVitals[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: vital.isNormal
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.red.withValues(alpha: 0.2),
              child: Icon(
                _getVitalIcon(vital.vitalType),
                color: vital.isNormal ? Colors.green : Colors.red,
              ),
            ),
            title: Text(_getVitalLabel(vital.vitalType)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vital.secondaryValue != null
                      ? '${vital.value.toStringAsFixed(0)}/${vital.secondaryValue!.toStringAsFixed(0)} ${vital.unit}'
                      : '${vital.value.toStringAsFixed(1)} ${vital.unit}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(_formatDateTime(vital.recordedAt)),
              ],
            ),
            trailing: Chip(
              label: Text(vital.statusLabel),
              backgroundColor: vital.isNormal
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.red.withValues(alpha: 0.2),
            ),
            onTap: () {
              // Show detail dialog
              _showVitalDetail(context, vital);
            },
          ),
        );
      },
    );
  }

  IconData _getVitalIcon(String type) {
    switch (type) {
      case 'blood_pressure':
        return Icons.favorite;
      case 'heart_rate':
        return Icons.monitor_heart;
      case 'blood_sugar':
        return Icons.water_drop;
      case 'weight':
        return Icons.monitor_weight;
      case 'temperature':
        return Icons.thermostat;
      case 'oxygen':
        return Icons.air;
      default:
        return Icons.health_and_safety;
    }
  }

  String _getVitalLabel(String type) {
    switch (type) {
      case 'blood_pressure':
        return 'Blood Pressure';
      case 'heart_rate':
        return 'Heart Rate';
      case 'blood_sugar':
        return 'Blood Sugar';
      case 'weight':
        return 'Weight';
      case 'temperature':
        return 'Temperature';
      case 'oxygen':
        return 'Oxygen Level';
      default:
        return type;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _showVitalTypeFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: _vitalTypes.map((vitalType) {
          return ListTile(
            leading: Icon(vitalType['icon'] as IconData),
            title: Text(vitalType['label'] as String),
            onTap: () {
              setState(() {
                _selectedVitalType = vitalType['type'] as String?;
              });
              ref
                  .read(vitalsViewmodelProvider.notifier)
                  .setVitalType(_selectedVitalType);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  void _showVitalDetail(BuildContext context, vital) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getVitalLabel(vital.vitalType)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vital.secondaryValue != null
                  ? '${vital.value.toStringAsFixed(0)}/${vital.secondaryValue!.toStringAsFixed(0)} ${vital.unit}'
                  : '${vital.value.toStringAsFixed(1)} ${vital.unit}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Status: ${vital.statusLabel}'),
            Text('Recorded: ${_formatDateTime(vital.recordedAt)}'),
            if (vital.notes != null) ...[
              const SizedBox(height: 12),
              Text('Notes: ${vital.notes}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(vitalsViewmodelProvider.notifier).deleteVital(vital.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
