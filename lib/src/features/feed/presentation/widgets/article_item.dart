// lib/src/features/feed/presentation/widgets/article_item_widget.dart
import 'package:flutter/material.dart';
import 'package:lafyamind_app/src/features/feed/domain/feed_item.dart';
// TODO: Add url_launcher package

class ArticleItemWidget extends StatelessWidget {
  final ArticleItem item;

  const ArticleItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Basic placeholder - enhance later
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      clipBehavior:
          Clip.antiAlias, // Ensures image corners are rounded with the card
      child: InkWell(
        // onTap: () => _launchURL(item.url), // Add URL launcher logic
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.imageUrl != null)
              Image.network(
                item.imageUrl!,
                height: 180, // Example height
                width: double.infinity,
                fit: BoxFit.cover,
                // Add error handling later
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.source,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.blueAccent)),
                  const SizedBox(height: 4.0),
                  Text(item.title,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8.0),
                  Text(item.summary,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8.0),
                  Text(
                    'Published: ${item.timestamp.toLocal()}', // Format as needed
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TODO: Implement URL launching
  // Future<void> _launchURL(String url) async {
  //   final Uri uri = Uri.parse(url);
  //    if (!await launchUrl(uri)) {
  //       throw Exception('Could not launch $url');
  //    }
  // }
}
