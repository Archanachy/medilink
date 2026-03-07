import 'package:flutter/material.dart';

class TimeSlotPicker extends StatelessWidget {
  final List<String> timeSlots;
  final String? selectedStart;
  final String? selectedEnd;
  final ValueChanged<String?> onStartChanged;
  final ValueChanged<String?> onEndChanged;

  const TimeSlotPicker({
    super.key,
    required this.timeSlots,
    required this.selectedStart,
    required this.selectedEnd,
    required this.onStartChanged,
    required this.onEndChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Start Time'),
        DropdownButtonFormField<String>(
          initialValue: selectedStart,
          items: timeSlots
              .map((slot) => DropdownMenuItem(value: slot, child: Text(slot)))
              .toList(),
          onChanged: onStartChanged,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        const Text('End Time'),
        DropdownButtonFormField<String>(
          initialValue: selectedEnd,
          items: timeSlots
              .map((slot) => DropdownMenuItem(value: slot, child: Text(slot)))
              .toList(),
          onChanged: onEndChanged,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }
}
