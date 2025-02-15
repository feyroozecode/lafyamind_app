import 'package:flutter/material.dart';
import 'package:lafyamind_app/src/constants/app_size.dart';
import 'package:lafyamind_app/src/constants/app_spacing.dart';

class DayHomourWidget extends StatefulWidget {
  const DayHomourWidget({super.key});

  @override
  State<DayHomourWidget> createState() => _DayHomourWidgetState();
}

class _DayHomourWidgetState extends State<DayHomourWidget> {
  _getMoodColor(int mood) {
    switch (mood) {
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
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: screenPadding,
        child: Column(
          children: [
            const Text("Comment vous sentez-vous aujourd’hui ?",
                style: TextStyle(fontSize: 18)),
            gapH12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [1, 2, 3, 4, 5]
                  .map((mood) => IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.sentiment_very_satisfied_outlined,
                          color: _getMoodColor(mood),
                        ),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
