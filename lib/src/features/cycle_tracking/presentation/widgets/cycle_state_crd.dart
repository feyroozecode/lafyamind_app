// lib/src/features/cycle_tracking/presentation/widgets/cycle_stats_card.dart
import 'package:flutter/material.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/models/cycle_data.dart';

class CycleStatsCard extends StatelessWidget {
  final CycleData cycle;

  const CycleStatsCard({
    Key? key,
    required this.cycle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentDay = cycle.getCurrentCycleDay();
    final phase = cycle.getCurrentPhase();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jour $currentDay de votre cycle',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _getPhaseDescription(phase),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: currentDay / cycle.cycleLength,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getPhaseColor(phase),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  context,
                  icon: Icons.calendar_today,
                  label: 'Prochaine règles',
                  value: _formatDate(cycle.getPredictedNextPeriod()),
                ),
                _buildStatItem(
                  context,
                  icon: Icons.loop,
                  label: 'Durée du cycle',
                  value: '${cycle.cycleLength} jours',
                ),
                _buildStatItem(
                  context,
                  icon: Icons.opacity,
                  label: 'Durée du cycle',
                  value: '${cycle.periodLength} jorus',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }

  String _getPhaseDescription(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'Menstrual Phase';
      case CyclePhase.follicular:
        return 'Follicular Phase';
      case CyclePhase.ovulation:
        return 'Ovulation Phase';
      case CyclePhase.luteal:
        return 'Luteal Phase';
      default:
        return '';
    }
  }

  Color _getPhaseColor(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return Colors.red;
      case CyclePhase.follicular:
        return Colors.green;
      case CyclePhase.ovulation:
        return Colors.blue;
      case CyclePhase.luteal:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}';
  }
}
