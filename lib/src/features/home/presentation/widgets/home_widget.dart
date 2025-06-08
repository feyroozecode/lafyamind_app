// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:lafyamind_app/src/features/feed/presentation/feed_screen.dart';
// import 'package:lafyamind_app/src/features/home/state/home_provider.dart';
// import 'package:lafyamind_app/src/features/home/presentation/widgets/emergency_help_card.dart';
// import 'package:lafyamind_app/src/features/home/presentation/widgets/mood_tracker_card.dart';

// import '../../../chatbot/presentation/chatbot_screen.dart';
// import '../../../core/common_import.dart';

// class HomeWidget extends StatefulHookConsumerWidget {
//   const HomeWidget({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _HomeWidgetState();
// }

// class _HomeWidgetState extends ConsumerState<HomeWidget> {
//   @override
//   Widget build(BuildContext context) {
//     final loclaUserProvider = ref.watch(localUserDataProvider);
//     final textTheme = Theme.of(context).textTheme;
//     final colorScheme = Theme.of(context).colorScheme;

//     return Scaffold(

//         //padding: screenPadding,
//         body: Container(
//       margin: pad12,
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Un bon retour cher ${loclaUserProvider?.name ?? 'Utilisateur'} !',
//               style: textTheme.headlineSmall?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             gapH8,
//             const MoodTrackerCard(),
//             gapH8,
//             const EmergencyHelpCard(),
//             gapH8,
//             Card(
//               color: Colors.white,
//               elevation: 2,
//               margin: EdgeInsets.zero,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
//                     child: Text(
//                       'Explorer',
//                       style: textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.dynamic_feed_rounded,
//                         color: colorScheme.primary),
//                     title: const Text('Fil d\'actualité'),
//                     subtitle: const Text('Articles, posts et vidéos'),
//                     trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                     onTap: () {
//                       context.push(const FeedListScreen());
//                     },
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.chat_bubble_outline_rounded,
//                         color: colorScheme.primary),
//                     title: const Text('Assistant IA'),
//                     subtitle: const Text('Discuter avec notre chatbot'),
//                     trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                     onTap: () {
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                           content: Text(
//                               'Navigation vers le Chatbot (à implémenter)')));
//                       context.push(const ChatbotScreen());
//                     },
//                   ),
//                   const Divider(height: 1, indent: 12, endIndent: 12),
//                   ListTile(
//                     leading:
//                         Icon(Icons.school_outlined, color: colorScheme.primary),
//                     title: const Text('Apprendre'),
//                     subtitle: const Text('Ressources et éducation'),
//                     trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                     onTap: () {
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                           content: Text(
//                               'Navigation vers Apprendre (à implémenter)')));
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             gapH16,
//           ],
//         ),
//       ),
//     ));
//   }
// }

// lib/src/features/home/presentation/widgets/home_widget.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lafyamind_app/src/constants/app_spacing.dart';
import 'package:lafyamind_app/src/features/core/common_import.dart';
import 'package:lafyamind_app/src/features/cycle_tracking/presentation/widgets/home_cycle_status.dart';
import 'package:lafyamind_app/src/features/home/state/home_provider.dart';
import 'package:lafyamind_app/src/features/home/presentation/widgets/emergency_help_card.dart';
import 'package:lafyamind_app/src/features/home/presentation/widgets/mood_tracker_card.dart';

class HomeWidget extends StatefulHookConsumerWidget {
  const HomeWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    final localUserProvider = ref.watch(localUserDataProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        margin: pad12,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenue , ${localUserProvider?.name ?? 'Friend'}!',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              gapH16,

              // Add the cycle tracking card at the top
              const HomeCycleStatusCard(),
              gapH16,

              // Keep the existing mood tracker
              const MoodTrackerCard(),
              gapH16,

              // Keep the emergency help card
              const EmergencyHelpCard(),
              gapH16,

              // Rest of the existing content
              // ...
            ],
          ),
        ),
      ),
    );
  }
}
