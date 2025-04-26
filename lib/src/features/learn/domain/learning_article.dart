    // lib/src/features/learning/domain/learning_article.dart

    class LearningArticle {
      final String id;
      final String title;
      final String category; // e.g., Anxiety, Depression, Stress Management
      final String author; // Optional: Author or Source
      final String summary;
      final String fullContent; // Could be markdown or plain text
      final String? imageUrl; // Optional header image
      final Duration estimatedReadTime;

      LearningArticle({
        required this.id,
        required this.title,
        required this.category,
        required this.author,
        required this.summary,
        required this.fullContent,
        this.imageUrl,
        required this.estimatedReadTime,
      });
    }