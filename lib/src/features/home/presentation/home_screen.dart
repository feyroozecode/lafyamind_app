import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lafyamind_app/src/features/chatbot/presentation/chatbot_screen.dart';
import 'package:lafyamind_app/src/features/feed/presentation/feed_screen.dart';
import 'package:lafyamind_app/src/features/home/presentation/widgets/home_widget.dart';

import '../../../constants/app_colors.dart';
import '../../learn/presentation/learn_screen.dart';

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
          : i == 1
              ? const FeedListScreen()
              : i == 2
                  ? const LearningScreen()
                  : SizedBox(
                      child: Center(
                        child: Text("Screen $i"),
                      ),
                    ));
  List<BottomNavigationBarItem> items = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(label: "Aujhourdui", icon: Icon(Icons.home)),
    const BottomNavigationBarItem(
        label: "Posts", icon: FaIcon(FontAwesomeIcons.rss)),
    const BottomNavigationBarItem(
        label: "Apprendre", icon: FaIcon(FontAwesomeIcons.book)),
    const BottomNavigationBarItem(label: "Plus", icon: Icon(Icons.more_horiz))
  ];

  // screenTitle
  String getScreenTitle() {
    switch (selectedTab) {
      case 0:
        return 'Lafyamind';
      case 1:
        return 'Articles';
      case 2:
        return 'Apprendre';
      case 3:
        return 'Plus';
      default:
        return 'Accueil';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getScreenTitle(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification button press
            },
          ),
        ],
      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ChatbotScreen(),
          ));
        },
        child: const FaIcon(FontAwesomeIcons.robot),
      ),
      //persistentFooterAlignment: AlignmentDirectional.center,
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
    );
  }
}
