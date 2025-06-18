import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lafyamind_app/src/features/chatbot/presentation/chatbot_screen.dart';
import 'package:lafyamind_app/src/features/chatbot/presentation/gemeni_chat.dart';
import 'package:lafyamind_app/src/features/feed/presentation/feed_screen.dart';
import 'package:lafyamind_app/src/features/home/presentation/widgets/home_widget.dart';
import 'package:lafyamind_app/src/features/learn/presentation/learn_screen.dart';
import '../../auth/providers/auth_providers.dart';
import '../../auth/models/user_model.dart';

import '../../../constants/app_colors.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
    final user = ref.watch(currentUserProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final sessionTimer = ref.watch(sessionTimerProvider);

    // Redirect to login if not authenticated
    if (!isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getScreenTitle(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                )),
            if (user != null)
              Text(
                'Hello, ${user.name}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        actions: [
          // Session timer indicator
          sessionTimer.when(
            data: (timeRemaining) {
              if (timeRemaining == null) return const SizedBox.shrink();
              final minutes = timeRemaining.inMinutes;
              final isExpiringSoon = timeRemaining.inMinutes < 2;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isExpiringSoon ? Colors.red.shade100 : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Ionicons.time_outline,
                      size: 14,
                      color: isExpiringSoon ? Colors.red.shade600 : Colors.green.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${minutes}m',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isExpiringSoon ? Colors.red.shade600 : Colors.green.shade600,
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification button press
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (String value) {
              switch (value) {
                case 'refresh':
                  authNotifier.refreshToken();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Session refreshed'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  break;
                case 'logout':
                  _showLogoutDialog(context);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Ionicons.refresh_outline),
                    SizedBox(width: 8),
                    Text('Refresh Session'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Ionicons.log_out_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
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
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => GeminiChatScreen())),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Ionicons.log_out_outline,
                color: Colors.red.shade600,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text('Confirm Logout'),
            ],
          ),
          content: const Text(
            'Are you sure you want to logout? You will need to sign in again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(authNotifierProvider.notifier).logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
