import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/availability/presentation/providers/availability_providers.dart';
import 'package:medilink/features/availability/presentation/state/availability_state.dart';
import 'package:table_calendar/table_calendar.dart';

class DoctorAvailabilityCalendarWidget extends ConsumerStatefulWidget {
  final String doctorId;
  final Function(DateTime)? onDateSelected;

  const DoctorAvailabilityCalendarWidget({
    super.key,
    required this.doctorId,
    this.onDateSelected,
  });

  @override
  ConsumerState<DoctorAvailabilityCalendarWidget> createState() =>
      _DoctorAvailabilityCalendarWidgetState();
}

class _DoctorAvailabilityCalendarWidgetState
    extends ConsumerState<DoctorAvailabilityCalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    // Load schedule for the current month
    _loadScheduleForMonth(_focusedDay);
  }

  void _loadScheduleForMonth(DateTime date) {
    final startDate = DateTime(date.year, date.month, 1);
    final endDate = DateTime(date.year, date.month + 1, 0);

    ref
        .read(availabilityViewmodelProvider.notifier)
        .loadDoctorSchedule(widget.doctorId, startDate: startDate, endDate: endDate);
  }

  @override
  Widget build(BuildContext context) {
    final availabilityState = ref.watch(availabilityViewmodelProvider);

    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            widget.onDateSelected?.call(selectedDay);
            ref
                .read(availabilityViewmodelProvider.notifier)
                .loadAvailableSlots(widget.doctorId, selectedDay);
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
            _loadScheduleForMonth(focusedDay);
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          calendarStyle: CalendarStyle(
            markersMaxCount: 1,
            markerDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (_hasAvailableSlots(date, availabilityState.schedule?.slots ?? [])) {
                return Positioned(
                  bottom: 1,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                );
              }
              if (_isHoliday(date, availabilityState.schedule?.holidays ?? [])) {
                return Positioned(
                  bottom: 1,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                );
              }
              return null;
            },
          ),
        ),
        if (availabilityState.status == AvailabilityStatus.loading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        if (_selectedDay != null && availabilityState.availableSlots.isNotEmpty)
          Expanded(
            child: _buildAvailableSlotsList(availabilityState.availableSlots),
          ),
        if (_selectedDay != null && availabilityState.availableSlots.isEmpty &&
            availabilityState.status == AvailabilityStatus.loaded)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No available slots for this date'),
          ),
      ],
    );
  }

  Widget _buildAvailableSlotsList(List slots) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.access_time),
            title: Text('${slot.startTime} - ${slot.endTime}'),
            trailing: slot.isAvailable
                ? const Chip(
                    label: Text('Available'),
                    backgroundColor: Colors.green,
                  )
                : const Chip(
                    label: Text('Booked'),
                    backgroundColor: Colors.grey,
                  ),
            onTap: slot.isAvailable
                ? () {
                    // Handle slot selection for booking
                    Navigator.pop(context, slot);
                  }
                : null,
          ),
        );
      },
    );
  }

  bool _hasAvailableSlots(DateTime date, List slots) {
    return slots.any((slot) =>
        isSameDay(slot.date, date) && slot.isAvailable);
  }

  bool _isHoliday(DateTime date, List<DateTime> holidays) {
    return holidays.any((holiday) => isSameDay(holiday, date));
  }
}
