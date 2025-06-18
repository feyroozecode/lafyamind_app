enum FeedItemType { post, article, video }

abstract class FeedItem {
  final String id;
  final String title;
  final DateTime timestamp;
  final FeedItemType type;

  FeedItem({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.type,
  });
}

class PostItem extends FeedItem {
  final String author;
  final String content;
  final String? imageUrl;

  PostItem({
    required String id,
    required String title,
    required this.author,
    required this.content,
    this.imageUrl,
    required DateTime timestamp,
  }) : super(
            id: id,
            title: title,
            timestamp: timestamp,
            type: FeedItemType.post);
}

class ArticleItem extends FeedItem {
  final String source;
  final String summary;
  final String url;
  final String? imageUrl;

  ArticleItem({
    required String id,
    required String title,
    required this.source,
    required this.summary,
    required this.url,
    this.imageUrl,
    required DateTime timestamp,
  }) : super(
            id: id,
            title: title,
            timestamp: timestamp,
            type: FeedItemType.article);
}

class VideoItem extends FeedItem {
  final String channel;
  final String videoUrl;
  final String thumbnailUrl;

  VideoItem({
    required String id,
    required String title,
    required this.channel,
    required this.videoUrl,
    required this.thumbnailUrl,
    required DateTime timestamp,
  }) : super(
            id: id,
            title: title,
            timestamp: timestamp,
            type: FeedItemType.video);
}
