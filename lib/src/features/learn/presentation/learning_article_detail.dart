import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // Import Markdown package
import 'package:lafyamind_app/src/features/core/common_import.dart';

import '../domain/learning_article.dart'; // Assuming you have this for gaps
import '../state/mental_health_provider.dart';

class LearningArticleScreen extends StatelessWidget {
  final LearningArticle article;

  const LearningArticleScreen({
    super.key,
    required this.article,
  });

  // Optional: Static route helper for navigation
  static Route<dynamic> route(LearningArticle article) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => LearningArticleScreen(article: article),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(article
            .category), // Show category in AppBar maybe? Or keep title short
        // title: Text(article.title), // Alternative: Show full title
      ),
      body: SingleChildScrollView(
        // Make the content scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article Title
              Text(
                article.title,
                style: textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              gapH12,

              // Metadata Section (Author, Read Time)
              Wrap(
                // Use Wrap for flexibility on smaller screens
                spacing: 16.0, // Horizontal space between items
                runSpacing: 4.0, // Vertical space if items wrap
                children: [
                  _buildMetadataChip(
                    icon: Icons.person_outline,
                    label: article.author,
                    context: context,
                  ),
                  _buildMetadataChip(
                    icon: Icons.timer_outlined,
                    // Format duration nicely
                    label:
                        '${article.estimatedReadTime.inMinutes} min de lecture',
                    context: context,
                  ),
                ],
              ),
              gapH16,

              // Optional Header Image
              if (article.imageUrl != null) ...[
                ClipRRect(
                  // Add rounded corners to the image
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    article.imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // Add placeholder/error handling for network image
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                            child: Icon(Icons.broken_image_outlined)),
                      );
                    },
                  ),
                ),
                gapH16,
              ],

              // Divider before content
              const Divider(),
              gapH16,

              // Main Content (Rendered as Markdown)
              // Check if fullContent is a file path or direct content
              article.fullContent.startsWith('assets/')
                  ? FutureBuilder<String>(
                      future: loadMarkdownContent(article.fullContent),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Erreur de chargement: ${snapshot.error}',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          return MarkdownBody(
                            data: snapshot.data!,
                            selectable: true,
                            styleSheet:
                                MarkdownStyleSheet.fromTheme(Theme.of(context))
                                    .copyWith(
                              p: textTheme.bodyLarge?.copyWith(fontSize: 16),
                              h1: textTheme.headlineSmall,
                              h2: textTheme.titleLarge,
                            ),
                            onTapLink: (text, href, title) {
                              if (href != null) {
                                print('Tapped link: $href');
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Lien cliqué (à implémenter) : $href')));
                              }
                            },
                          );
                        } else {
                          return const Text('Aucun contenu disponible');
                        }
                      },
                    )
                  : MarkdownBody(
                      data: article.fullContent,
                      selectable: true, // Allow users to select/copy text
                      // Optional: Style Markdown elements
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context))
                              .copyWith(
                        p: textTheme.bodyLarge
                            ?.copyWith(fontSize: 16), // Adjust paragraph style
                        h1: textTheme.headlineSmall,
                        h2: textTheme.titleLarge,
                        // Add other styles as needed
                      ),
                      onTapLink: (text, href, title) {
                        // TODO: Handle link taps (e.g., open in browser using url_launcher)
                        if (href != null) {
                          print('Tapped link: $href');
                          // Example: launchUrl(Uri.parse(href));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Lien cliqué (à implémenter) : $href')));
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for metadata chips for better visual grouping
  Widget _buildMetadataChip({
    required IconData icon,
    required String label,
    required BuildContext context,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(icon, size: 18, color: colorScheme.primary),
      label: Text(label),
      labelStyle: textTheme.bodyMedium,
      backgroundColor: colorScheme.primaryContainer.withOpacity(0.2),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }
}
