
// Provider for mood history
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/mood_entry.dart';

final moodlistProvider = StateProvider<List<MoodEntry>>((ref) => // Static data for testing
[
  MoodEntry(date: DateTime.now().subtract(const Duration(days: 6)), moodLevel: 3, note: "Feeling okay"),
  MoodEntry(date: DateTime.now().subtract(const Duration(days: 5)), moodLevel: 4, note: "Good day"),
  MoodEntry(date: DateTime.now().subtract(const Duration(days: 4)), moodLevel: 2, note: "Stressed"),
  MoodEntry(date: DateTime.now().subtract(const Duration(days: 3)), moodLevel: 5, note: "Great day!"),
  MoodEntry(date: DateTime.now().subtract(const Duration(days: 2)), moodLevel: 3, note: null),
  MoodEntry(date: DateTime.now().subtract(const Duration(days: 1)), moodLevel: 4, note: "Productive"),
]
);

final moodHistoryProvider = Provider<List<MoodEntry>>((ref) {
  return ref.watch(moodlistProvider).reversed.toList();
});

// Provider for current mood selection
final currentMoodProvider = StateProvider<int>((ref) => 3); // Default to neutral mood

// Provider for mood note
final moodNoteProvider = StateProvider<String>((ref) => '');
