import 'package:lafyamind_app/src/features/core/common_import.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lafyamind_app/src/features/home/core/application/mood_notifier.dart';

class DayHomourWidget extends ConsumerWidget {
  DayHomourWidget({super.key});

  final List<Map<String, dynamic>> humourMoodList = [
    {"level": 1, "color": Colors.red, "icon": Icons.sentiment_dissatisfied},
    {"level": 2, "color": Colors.orange, "icon": Icons.sentiment_neutral},
    {
      "level": 3,
      "color": Colors.yellow,
      "icon": Icons.sentiment_dissatisfied_sharp
    },
    {"level": 4, "color": Colors.green, "icon": Icons.sentiment_satisfied},
    {
      "level": 5,
      "color": Colors.blue,
      "icon": Icons.sentiment_dissatisfied_sharp
    }
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final humourlevel = ref.watch(moodlevelProvider.notifier);

    return Card(
      margin: screenPadding,
      child: Padding(
          padding: screenPadding,
          child: Column(
            children: [
              Text("Comment vous sentez-vous aujourd’hui ?",
                  style: context.theme.textTheme.headlineMedium),
              gapH12,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: humourMoodList
                    .map((mood) => IconButton(
                        onPressed: () {
                          humourlevel.updateMood(mood['level']);
                          print(ref.watch(moodlevelProvider));
                        },
                        icon: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: Icon(
                            mood['icon'],
                            color: mood['color'],
                            size: ref.watch(moodlevelProvider) == mood['level']
                                ? 42
                                : 28,
                          ),
                        )))
                    .toList(),
              )
            ],
          )),
    );
  }
}
