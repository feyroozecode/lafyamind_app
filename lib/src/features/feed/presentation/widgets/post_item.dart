// lib/src/features/feed/presentation/widgets/post_item_widget.dart
import 'package:flutter/material.dart';
import 'package:lafyamind_app/src/features/feed/domain/feed_item.dart';

class PostItemWidget extends StatelessWidget {
  final PostItem item;

  const PostItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8.0),
            Text('By ${item.author}',
                style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8.0),
            if (item.imageUrl != null) ...[
              Image.network(item.imageUrl!), // Add error handling later
              const SizedBox(height: 8.0),
            ],
            Text(item.content),
            const SizedBox(height: 8.0),
            Text(
              'Posted: ${item.timestamp.toLocal()}', // Format as needed
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
