import 'package:flutter/material.dart';
import 'package:lafyamind_app/src/constants/app_spacing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;

  List<Widget> screens = List.generate(
      4,
      (int i) => SizedBox(
            child: Center(
              child: Text("Screen $i"),
            ),
          ));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: screenPadding,
      child: SafeArea(child: Scaffold(
        body: screens[selectedTab],
        bottomNavigationBar: BottomNavigationBar(
          items: List.generate(
              4,
              (el) => BottomNavigationBarItem(
                  icon: el / 2 == 0
                      ? const Icon(Icons.home)
                      : const Icon(Icons.explore)
                    )
              ),
        ),
      )),
    );
  }
}
