import 'package:flutter/material.dart';
import 'package:lafyamind_app/src/constants/app_size.dart';
import 'package:lafyamind_app/src/constants/app_spacing.dart';

class DayHomourWidget extends StatefulWidget {
  const DayHomourWidget({super.key});

  @override
  State<DayHomourWidget> createState() => _DayHomourWidgetState();
}

class _DayHomourWidgetState extends State<DayHomourWidget> {
  //List<int> humourStateList = [1, 2, 3, 4, 5];

  final Set<List<Map<String, dynamic>>> _getMoodData =
  {
    [
      {
    
          "color":  Colors.red,
          "icon": Icons.sentiment_dissatisfied
        },
        {
          "color":  Colors.orange,
          "icon": Icons.sentiment_neutral
        },
 {
          "color":  Colors.yellow,
          "icon": Icons.sentiment_dissatisfied_sharp
        },
 {
          "color":  Colors.green,
          "icon": Icons.sentiment_satisfied
        },

        {
          "color":  Colors.blue,
          "icon": Icons.sentiment_dissatisfied_sharp
        };
        
    ]
  };

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
              children: humourStateList
                  .map((mood) => IconButton(
                        onPressed: () {},
                        icon: Icon(
                          mood== 1? 
                          Icons.sentiment_very_satisfied_outlined ,
                          color: _getMoodData(mood).entries.map((m)=> m.value['color'] as Color),
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
