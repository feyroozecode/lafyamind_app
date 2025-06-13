// lib/src/features/cycle_tracking/presentation/screens/cycle_tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/application/providers.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/models/cycle_data.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/presentation/widgets/cycle_calender.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/presentation/widgets/cycle_state_crd.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/presentation/widgets/first_cycle_form.dart';

class CycleTrackingScreen extends ConsumerWidget {
  const CycleTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCycleAsync = ref.watch(currentCycleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Cycle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to cycle settings
            },
          ),
        ],
      ),
      body: currentCycleAsync.when(
        data: (cycle) => cycle != null
            ? _buildCycleTrackingUI(context, ref, cycle)
            : const FirstCycleForm(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildCycleTrackingUI(
      BuildContext context, WidgetRef ref, CycleData cycle) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cycle stats card
          CycleStatsCard(cycle: cycle),

          // Calendar for cycle visualization
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Calendar',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          CycleCalendar(cycle: cycle),

          // Day log editor
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Log for ${_formatDate(ref.watch(selectedDateProvider))}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          //const DayLogEditor(),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
