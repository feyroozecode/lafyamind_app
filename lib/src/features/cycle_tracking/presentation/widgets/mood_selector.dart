import 'package:flutter/cupertino.dart';
import 'package:lafyamind_app/src/features/core/common_import.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/models/cycle_data.dart';

class MMoodSelector extends StatelessWidget {
  final MoodType? selectedMood;
  final Function(MoodType) onMoodSelected;

  const MMoodSelector({
    Key? key,
    required this.selectedMood,
    required this.onMoodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: MoodType.values.map((mood) {
          final isSelected = selectedMood == mood;
          return _buildMoodOption(mood, isSelected);
        }).toList(),
      ),
    );
  }

  Widget _buildMoodOption(MoodType mood, bool isSelected) {
    return GestureDetector(
      onTap: () => onMoodSelected(mood),
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getMoodEmoji(mood),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              _getMoodLabel(mood),
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getMoodEmoji(MoodType mood) {
    switch (mood) {
      case MoodType.happy:
        return '😊';
      case MoodType.calm:
        return '😌';
      case MoodType.sensitive:
        return '🥺';
      case MoodType.sad:
        return '😢';
      case MoodType.anxious:
        return '😰';
      case MoodType.irritable:
        return '😠';
      case MoodType.energetic:
        return '⚡';
      case MoodType.tired:
        return '😴';
      case MoodType.stressed:
        return '😫';
      case MoodType.other:
        return '🤔';
      default:
        return '';
    }
  }

  String _getMoodLabel(MoodType mood) {
    switch (mood) {
      case MoodType.happy:
        return 'Happy';
      case MoodType.calm:
        return 'Calm';
      case MoodType.sensitive:
        return 'Sensitive';
      case MoodType.sad:
        return 'Sad';
      case MoodType.anxious:
        return 'Anxious';
      case MoodType.irritable:
        return 'Irritable';
      case MoodType.energetic:
        return 'Energetic';
      case MoodType.tired:
        return 'Tired';
      case MoodType.stressed:
        return 'Stressed';
      case MoodType.other:
        return 'Other';
      default:
        return '';
    }
  }
}
