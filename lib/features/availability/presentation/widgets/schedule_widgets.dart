import 'package:flutter/material.dart';
import 'package:medilink/features/availability/domain/entities/availability_entity.dart';

class WeeklyScheduleWidget extends StatelessWidget {
  final DoctorSchedule schedule;

  const WeeklyScheduleWidget({
    super.key,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    final daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_view_week, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Weekly Schedule',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...daysOfWeek.map((day) => _buildDaySchedule(context, day, schedule.weeklySchedule[day] ?? [])),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySchedule(BuildContext context, String day, List<String> slots) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              day,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Expanded(
            child: slots.isEmpty
                ? Text(
                    'Not available',
                    style: TextStyle(color: Colors.grey[600]),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: slots
                        .map((slot) => Chip(
                              label: Text(slot),
                              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            ))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class MonthlyScheduleWidget extends StatefulWidget {
  final DoctorSchedule schedule;

  const MonthlyScheduleWidget({
    super.key,
    required this.schedule,
  });

  @override
  State<MonthlyScheduleWidget> createState() => _MonthlyScheduleWidgetState();
}

class _MonthlyScheduleWidgetState extends State<MonthlyScheduleWidget> {
  DateTime _currentMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startingWeekday = firstDayOfMonth.weekday;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
                    });
                  },
                ),
                Text(
                  '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Weekday headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                  .map((day) => SizedBox(
                        width: 40,
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            // Calendar grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: 42, // 6 weeks
              itemBuilder: (context, index) {
                final dayNumber = index - startingWeekday + 2;
                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const SizedBox();
                }

                final date = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
                final hasSlots = _hasAvailableSlots(date);
                final isHoliday = _isHoliday(date);

                return Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isHoliday
                        ? Colors.red.withValues(alpha: 0.1)
                        : hasSlots
                            ? Colors.green.withValues(alpha: 0.1)
                            : null,
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      dayNumber.toString(),
                      style: TextStyle(
                        color: isHoliday ? Colors.red : Colors.black,
                        fontWeight: hasSlots ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(context, Colors.green, 'Available'),
                const SizedBox(width: 16),
                _buildLegendItem(context, Colors.red, 'Holiday'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  bool _hasAvailableSlots(DateTime date) {
    return widget.schedule.slots.any(
      (slot) =>
          slot.date.year == date.year &&
          slot.date.month == date.month &&
          slot.date.day == date.day &&
          slot.isAvailable,
    );
  }

  bool _isHoliday(DateTime date) {
    return widget.schedule.holidays.any(
      (holiday) =>
          holiday.year == date.year &&
          holiday.month == date.month &&
          holiday.day == date.day,
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
