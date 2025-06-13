
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
