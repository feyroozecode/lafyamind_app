// lib/src/features/cycle_tracking/presentation/widgets/cycle_calendar.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/application/providers.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/models/cycle_data.dart';
import 'package:table_calendar/table_calendar.dart';

class CycleCalendar extends ConsumerWidget {
  final CycleData cycle;

  const CycleCalendar({
    Key? key,
    required this.cycle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);

    return TableCalendar(
      firstDay: cycle.startDate.subtract(const Duration(days: 30)),
      lastDay: cycle.startDate.add(Duration(days: cycle.cycleLength + 30)),
      focusedDay: selectedDate,
      selectedDayPredicate: (day) {
        return isSameDay(selectedDate, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        ref.read(selectedDateProvider.notifier).state = selectedDay;
      },
      calendarStyle: CalendarStyle(
        // Customize calendar appearance
        todayDecoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: Colors.purple,
          shape: BoxShape.circle,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        // Custom day cell builder
        defaultBuilder: (context, day, focusedDay) {
          return _buildCalendarDay(day);
        },
      ),
    );
  }

  Widget _buildCalendarDay(DateTime day) {
    // Check if day is in period
    final cycleDay = day.difference(cycle.startDate).inDays + 1;
    final isInPeriod = cycleDay > 0 && cycleDay <= cycle.periodLength;

    // Check if day is in fertile window
    final midCycle = cycle.cycleLength ~/ 2;
    final isInFertileWindow =
        cycleDay > 0 && cycleDay >= midCycle - 5 && cycleDay <= midCycle + 1;

    // Check for logged data
    final dayLog = cycle.getDayLog(day);
    final hasFlow = dayLog?.flow != null;
    final hasSymptoms = dayLog?.symptoms.isNotEmpty ?? false;

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isInPeriod
            ? Colors.red.withOpacity(0.2)
            : isInFertileWindow
                ? Colors.blue.withOpacity(0.2)
                : null,
        border: hasFlow || hasSymptoms
            ? Border.all(color: Colors.purple, width: 2)
            : null,
      ),
      child: Center(
        child: Text(
          day.day.toString(),
          style: TextStyle(
            color: isInPeriod
                ? Colors.red
                : isInFertileWindow
                    ? Colors.blue
                    : null,
            fontWeight: hasFlow || hasSymptoms ? FontWeight.bold : null,
          ),
        ),
      ),
    );
  }
}
