// lib/src/features/cycle_tracking/presentation/widgets/home_cycle_status_card.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/application/providers.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/models/cycle_data.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/presentation/cycle_tracking_screen.dart';

class HomeCycleStatusCard extends ConsumerWidget {
  const HomeCycleStatusCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCycleAsync = ref.watch(currentCycleProvider);

    return Card(
      color: Colors.white,
      elevation: 2,
      child: currentCycleAsync.when(
        data: (cycle) => cycle != null
            ? _buildCycleStatusContent(context, cycle)
            : _buildNoCycleContent(context),
        loading: () => const SizedBox(
          height: 150,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => SizedBox(
          height: 150,
          child: Center(
            child: Text('Erreur: ${error.toString()}'),
          ),
        ),
      ),
    );
  }

  Widget _buildCycleStatusContent(BuildContext context, CycleData cycle) {
    final theme = Theme.of(context);
    final currentDay = cycle.getCurrentCycleDay();
    final phase = cycle.getCurrentPhase();

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CycleTrackingScreen(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mon Cycle',
                  style: theme.textTheme.titleLarge,
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildPhaseIndicator(phase),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jour $currentDay of ${cycle.cycleLength}',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getPhaseDescription(phase),
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: currentDay / cycle.cycleLength,
                        minHeight: 8,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getPhaseColor(phase),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoChip(
                  context,
                  label: 'Prochaines règle',
                  value: _formatDate(cycle.getPredictedNextPeriod()),
                  icon: Icons.calendar_today,
                  color: Colors.red.shade300,
                ),
                _buildQuickLogButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoCycleContent(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CycleTrackingScreen(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mon cycle',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Commencez à suivre votre cycle pour obtenir des informations et prédictions personnalisées..',
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const CycleTrackingScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Configurer mon cycle'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseIndicator(CyclePhase phase) {
    final color = _getPhaseColor(phase);

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          _getPhaseEmoji(phase),
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLogButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CycleTrackingScreen(),
          ),
        );
      },
      icon: const Icon(Icons.edit, size: 16),
      label: const Text('Journal d\'aujourd\'hui'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
      ),
    );
  }

  String _getPhaseDescription(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'Phase menstruelle';
      case CyclePhase.follicular:
        return 'Phase folliculaire';
      case CyclePhase.ovulation:
        return 'Phase d\'ovulation';
      case CyclePhase.luteal:
        return 'Phase lutéale';
      default:
        return '';
    }
  }

  String _getPhaseEmoji(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return '🌊';
      case CyclePhase.follicular:
        return '🌱';
      case CyclePhase.ovulation:
        return '🥚';
      case CyclePhase.luteal:
        return '🍃';
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
