import 'package:riverpod/riverpod.dart';

final moodProvider =
    StateNotifierProvider<MoodNotifier, int>((ref) => MoodNotifier());

class MoodNotifier extends StateNotifier<int> {
  MoodNotifier() : super(0);

  void updateMood(int newMood) {
    state = newMood;
    // Sauvegarder dans Hive/SQLite
  }
}
