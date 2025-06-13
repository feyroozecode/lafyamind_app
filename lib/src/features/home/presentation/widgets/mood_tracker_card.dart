import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lafyamind_app/src/constants/app_size.dart';

import '../../state/mood_provider.dart';

// Widget for selecting mood
class MoodSelector extends ConsumerWidget {
  const MoodSelector({super.key});

  final List<Map<String, dynamic>> moodList = const [
    {"level": 1, "color": Colors.red, "emoji": "😢"},
    {"level": 2, "color": Colors.orange, "emoji": "😕"},
    {"level": 3, "color": Colors.yellow, "emoji": "😐"},
    {"level": 4, "color": Colors.green, "emoji": "🙂"},
    {"level": 5, "color": Colors.blue, "emoji": "😄"}
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMood = ref.watch(currentMoodProvider);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: moodList
              .map((mood) => _buildMoodButton(ref, mood['level'], mood['emoji'],
                  mood['color'], currentMood))
              .toList(),
        ),
        gapH12,
        TextField(
          onChanged: (value) =>
              ref.read(moodNoteProvider.notifier).state = value,
          decoration: const InputDecoration(
            hintText: 'Ajoutez une note (optionnel)',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildMoodButton(WidgetRef ref, int moodValue, String emoji,
      Color color, int currentMood) {
    final isSelected = moodValue == currentMood;

    return GestureDetector(
      onTap: () => ref.read(currentMoodProvider.notifier).state = moodValue,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(isSelected ? 12 : 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          border: isSelected ? Border.all(color: color, width: 2) : null,
        ),
        child: Text(
          emoji,
          style: TextStyle(
            fontSize: isSelected ? 32 : 28,
          ),
        ),
      ),
    );
  }
}

// Update MoodHistoryView to use colors
class MoodHistoryView extends ConsumerWidget {
  const MoodHistoryView({super.key});

  Color _getMoodColor(int moodLevel) {
    switch (moodLevel) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.green;
      case 5:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodHistory = ref.watch(moodHistoryProvider);

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: moodHistory.length,
        itemBuilder: (context, index) {
          final entry = moodHistory[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Text(
                  _getMoodEmoji(entry.moodLevel),
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  '${entry.date.day}/${entry.date.month}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getMoodEmoji(int moodLevel) {
    switch (moodLevel) {
      case 1:
        return '😢';
      case 2:
        return '😕';
      case 3:
        return '😐';
      case 4:
        return '🙂';
      case 5:
        return '😄';
      default:
        return '😐';
    }
  }
}

// Main mood tracker card widget
class MoodTrackerCard extends ConsumerWidget {
  const MoodTrackerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Comment vous sentez-vous aujourd\'hui ?',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.history),
                  onPressed: () {
                    // Navigate to detailed mood history
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const MoodSelector(),
            gapH12,
            // const Divider(),
            // gapH12,
            // Text(
            //   'Historique de votre humeur',
            //   style: Theme.of(context).textTheme.titleMedium,
            // ),
            // const SizedBox(height: 8),
            // const MoodHistoryView(),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       final currentMood = ref.read(currentMoodProvider);
            //       final note = ref.read(moodNoteProvider);

            //       // In a real app, you would save this to your data source
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(
            //             content:
            //                 Text('Humeur enregistrée: Niveau $currentMood')),
            //       );

            //       // Reset note after saving
            //       ref.read(moodNoteProvider.notifier).state = '';
            //     },
            //     style: ElevatedButton.styleFrom(
            //       padding: const EdgeInsets.symmetric(vertical: 12),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //     ),
            //     child: const Text('Enregistrer l\'humeur du jour'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
