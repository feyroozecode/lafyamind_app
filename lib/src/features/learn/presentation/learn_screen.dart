import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lafyamind_app/src/constants/app_theme.dart';
import 'package:lafyamind_app/src/features/core/common_import.dart';

import 'learning_article_detail.dart'; // Use if you need Riverpod state later

class LearningScreen extends ConsumerWidget {
  // Or StatelessWidget if no state needed yet
  const LearningScreen({super.key});

  // Optional: Static route helper for navigation
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const LearningScreen());
  }

  // Optional: Route name for named routing (e.g., go_router)
  static const String routeName =
      'learn'; // Match the name used in home_widget.dart

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Apprendre'),
      //   // You might add actions later, e.g., search or filter
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // Use ListView for potentially scrollable content
          children: [
            // Placeholder for Learning Modules/Sections
            _buildLearningSection(
                context: context,
                icon: Icons.book_rounded,
                title: 'Comprendre la Santé Mentale',
                description: 'Articles et guides sur divers sujets.',
                onTap: () {
                  // TODO: Navigate to a specific sub-section or list of articles
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'Navigation vers les articles (à implémenter)')));
                
                // context.push(const LearningArticleScreen(
                //   article: learningArticlesProvider[0],
                // ));
                }),
            const SizedBox(height: 16),
            _buildLearningSection(
                context: context,
                icon: Icons.video_library_rounded,
                title: 'Vidéos Éducatives',
                description: 'Apprenez avec des experts en vidéo.',
                onTap: () {
                  // TODO: Navigate to video library section
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Navigation vers les vidéos (à implémenter)')));
                }),
            const SizedBox(height: 16),
            _buildLearningSection(
                context: context,
                icon: Icons.quiz_rounded,
                title: 'Quiz et Auto-évaluations',
                description: 'Testez vos connaissances.',
                onTap: () {
                  // TODO: Navigate to quizzes section
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Navigation vers les quiz (à implémenter)')));
                }),
            // Add more sections as needed
          ],
        ),
      ),
    );
  }

  // Helper widget to build consistent section cards
  Widget _buildLearningSection({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip
          .antiAlias, // Ensures InkWell ripple effect respects rounded corners
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40.0, color: colorScheme.primary),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      description,
                      style: textTheme.bodyMedium
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
