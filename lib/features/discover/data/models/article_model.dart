/// Article model for news and blog posts
class ArticleModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String articleUrl;
  final String source;
  final String category;
  final DateTime publishedDate;
  final String author;

  ArticleModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.articleUrl,
    required this.source,
    required this.category,
    required this.publishedDate,
    required this.author,
  });

  /// Get relative time (e.g., "2 hours ago")
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(publishedDate);

    if (difference.inDays > 7) {
      return '${difference.inDays ~/ 7}w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Get shortened description
  String getShortDescription({int maxLength = 150}) {
    if (description.length <= maxLength) return description;
    return '${description.substring(0, maxLength)}...';
  }
}
