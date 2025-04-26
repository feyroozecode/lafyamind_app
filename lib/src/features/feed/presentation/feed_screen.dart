import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lafyamind_app/src/features/feed/domain/feed_item.dart';

import '../state/feed_provider.dart';
import 'widgets/article_item.dart';
import 'widgets/post_item.dart';
import 'widgets/video_item.dart';

class FeedListScreen extends ConsumerWidget {
  const FeedListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the feedProvider to get the list of FeedItem objects
    final feedItems = ref.watch(feedProvider);

    // 2. Handle loading or empty states (though our current provider is synchronous)
    // If feedProvider were a FutureProvider or StreamProvider, you'd handle loading/error states here:
    // return feedItems.when(
    //   data: (items) => _buildList(context, items),
    //   loading: () => const Center(child: CircularProgressIndicator()),
    //   error: (err, stack) => Center(child: Text('Error: $err')),
    // );

    // For the current simple Provider:
    if (feedItems.isEmpty) {
      return const Center(child: Text('No items in the feed yet.'));
    }

    // 3. Build the list using ListView.builder
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      //   // title: const Text('Articles'),
      //   //elevation: 1,
      // ),
      body: _buildList(context, feedItems),
    );
  }

  Widget _buildList(BuildContext context, List<FeedItem> items) {
    return ListView.builder(
      // Add padding around the list if desired
      // padding: const EdgeInsets.all(8.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        // 4. Delegate rendering to specific item widgets based on type
        switch (item.type) {
          case FeedItemType.post:
            return PostItemWidget(item: item as PostItem);
          case FeedItemType.article:
            return ArticleItemWidget(item: item as ArticleItem);
          case FeedItemType.video:
            return VideoItemWidget(item: item as VideoItem);
          default:
            return const SizedBox
                .shrink(); // Or some placeholder for unknown types
        }
      },
    );
  }
}
