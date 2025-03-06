import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lafyamind_app/src/constants/app_spacing.dart';
import 'package:lafyamind_app/src/features/home/core/presentation/widgets/home_widget.dart';

import '../../../../constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;

  List<Widget> screens = List.generate(
      4,
      (int i) => i == 0
          ? const HomeWidget()
          : SizedBox(
              child: Center(
                child: Text("Screen $i"),
              ),
            ));
  List<BottomNavigationBarItem> items = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(label: "Aujhourdui", icon: Icon(Icons.home)),
    const BottomNavigationBarItem(
        label: "Bot", icon: FaIcon(FontAwesomeIcons.robot)),
    const BottomNavigationBarItem(
        label: "Apprendre", icon: FaIcon(FontAwesomeIcons.book)),
    const BottomNavigationBarItem(label: "Plus", icon: Icon(Icons.more_horiz))
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: screenPadding,
      child: SafeArea(
          child: Scaffold(
          backgroundColor: AppColors.background,
          body: screens[selectedTab],
          bottomNavigationBar: BottomNavigationBar(
            elevation: 10,
            currentIndex: selectedTab,
            selectedFontSize: 12,
            iconSize: 24,
            unselectedFontSize: 10,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            selectedIconTheme: const IconThemeData(size: 20),
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.grey,
            onTap: (int index) {
              setState(() {
                selectedTab = index;
              });
            },
            items: items,
        ),
        persistentFooterAlignment: AlignmentDirectional.center,
        // persistentFooterButtons: [
        //   Container(
        //     padding: const EdgeInsets.all(10),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(10),
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.grey.withOpacity(0.5),
        //           spreadRadius: 2,
        //           blurRadius: 5,
        //           offset: const Offset(0, 3),
        //         ),
        //       ],
        //     ),
        //     child: const Text(
        //       '© 2023 Lafyamind',
        //       style: TextStyle(
        //         fontSize: 12,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ],
      )
      ),
    );
  }
}
