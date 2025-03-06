import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/mood_provider.dart';

// Model for mood data
class MoodEntry {
  final DateTime date;
  final int moodLevel; // 1-5 where 1 is sad, 5 is happy
  final String? note;

  MoodEntry({
    required this.date,
    required this.moodLevel,
    this.note,
  });
}


// Widget for selecting mood
class MoodSelector extends ConsumerWidget {
  const MoodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMood = ref.watch(currentMoodProvider);
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildMoodButton(ref, 1, '😢', currentMood),
            _buildMoodButton(ref, 2, '😕', currentMood),
            _buildMoodButton(ref, 3, '😐', currentMood),
            _buildMoodButton(ref, 4, '🙂', currentMood),
            _buildMoodButton(ref, 5, '😄', currentMood),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) => ref.read(moodNoteProvider.notifier).state = value,
          decoration: const InputDecoration(
            hintText: 'Ajoutez une note (optionnel)',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildMoodButton(WidgetRef ref, int moodValue, String emoji, int currentMood) {
    final isSelected = moodValue == currentMood;
    
    return GestureDetector(
      onTap: () => ref.read(currentMoodProvider.notifier).state = moodValue,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
          border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
        ),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }
}

// Widget for displaying mood history
class MoodHistoryView extends ConsumerWidget {
  const MoodHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodHistory = ref.watch(moodHistoryProvider);
    
    return SizedBox(
      height: 100,
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
                  style: const TextStyle(fontSize: 24),
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
      case 1: return '😢';
      case 2: return '😕';
      case 3: return '😐';
      case 4: return '🙂';
      case 5: return '😄';
      default: return '😐';
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
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Historique de votre humeur',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const MoodHistoryView(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final currentMood = ref.read(currentMoodProvider);
                  final note = ref.read(moodNoteProvider);
                  
                  // In a real app, you would save this to your data source
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Humeur enregistrée: Niveau $currentMood')),
                  );
                  
                  // Reset note after saving
                  ref.read(moodNoteProvider.notifier).state = '';
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Enregistrer l\'humeur du jour'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}