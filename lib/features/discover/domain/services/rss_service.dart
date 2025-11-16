import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import '../../data/models/article_model.dart';

/// RSS Feed service for fetching Islamic finance content
class RssService {
  static final RssService instance = RssService._();
  RssService._();

  // RSS Feed sources
  static const List<RssFeedSource> feeds = [
    RssFeedSource(
      name: 'Republika Ekonomi Syariah',
      url: 'https://www.republika.co.id/rss/ekonomi-syariah',
      category: 'Ekonomi Syariah',
    ),
    RssFeedSource(
      name: 'Kontan Syariah',
      url: 'https://keuangan.kontan.co.id/rss/syariah',
      category: 'Keuangan Syariah',
    ),
    // Add more sources as needed
  ];

  /// Fetch articles from all RSS feeds
  Future<List<ArticleModel>> fetchAllArticles() async {
    final List<ArticleModel> allArticles = [];

    for (final feedSource in feeds) {
      try {
        final articles = await fetchFromFeed(feedSource);
        allArticles.addAll(articles);
      } catch (e) {
        // Log error but continue with other feeds
        print('Error fetching from ${feedSource.name}: $e');
      }
    }

    // Sort by date (newest first)
    allArticles.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));

    return allArticles;
  }

  /// Fetch articles from specific RSS feed
  Future<List<ArticleModel>> fetchFromFeed(RssFeedSource source) async {
    try {
      final response = await http.get(
        Uri.parse(source.url),
        headers: {'Accept': 'application/rss+xml, application/xml, text/xml'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final feed = RssFeed.parse(response.body);
        return _convertToArticles(feed, source);
      } else {
        throw Exception('Failed to load feed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching RSS feed: $e');
    }
  }

  /// Convert RSS items to ArticleModel
  List<ArticleModel> _convertToArticles(RssFeed feed, RssFeedSource source) {
    return feed.items?.map((item) {
      return ArticleModel(
        id: item.guid ?? item.link ?? DateTime.now().toString(),
        title: item.title ?? 'No Title',
        description: _cleanDescription(item.description ?? ''),
        imageUrl: _extractImageUrl(item),
        articleUrl: item.link ?? '',
        source: source.name,
        category: source.category,
        publishedDate: item.pubDate ?? DateTime.now(),
        author: item.author ?? source.name,
      );
    }).toList() ?? [];
  }

  /// Clean HTML from description
  String _cleanDescription(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll(RegExp(r'\s+'), ' ') // Clean whitespace
        .trim();
  }

  /// Extract image URL from RSS item
  String? _extractImageUrl(RssItem item) {
    // Try media:content
    if (item.media?.contents?.isNotEmpty ?? false) {
      return item.media!.contents!.first.url;
    }

    // Try media:thumbnail
    if (item.media?.thumbnails?.isNotEmpty ?? false) {
      return item.media!.thumbnails!.first.url;
    }

    // Try enclosure
    if (item.enclosure?.url != null) {
      return item.enclosure!.url;
    }

    // Try finding image in description
    final imgRegex = RegExp(r'<img[^>]+src="([^">]+)"');
    final match = imgRegex.firstMatch(item.description ?? '');
    if (match != null) {
      return match.group(1);
    }

    return null;
  }

  /// Get curated tips (hardcoded for now, can be from Firestore later)
  List<TipModel> getCuratedTips() {
    return [
      TipModel(
        id: '1',
        title: 'Cara Memulai Investasi Syariah',
        description: 'Panduan lengkap untuk pemula yang ingin investasi halal',
        category: 'Investasi',
        emoji: '📈',
        tips: [
          'Mulai dari reksadana syariah (low risk)',
          'Pelajari saham-saham yang masuk indeks syariah',
          'Diversifikasi portfolio dengan sukuk',
          'Hindari sektor haram (alkohol, judi, riba)',
        ],
      ),
      TipModel(
        id: '2',
        title: 'Mengelola Keuangan ala Rasulullah',
        description: 'Prinsip-prinsip keuangan dari sunnah Nabi',
        category: 'Edukasi',
        emoji: '🕌',
        tips: [
          'Sisihkan 1/3 untuk tabungan',
          'Bayar zakat tepat waktu',
          'Hindari hutang konsumtif',
          'Investasi untuk akhirat',
        ],
      ),
      TipModel(
        id: '3',
        title: 'Tips Nabung untuk Gen Z',
        description: 'Strategi saving yang works untuk anak muda',
        category: 'Saving',
        emoji: '💰',
        tips: [
          'Pakai metode 50/30/20 (kebutuhan/keinginan/tabungan)',
          'Automate saving dengan auto-debit',
          'Challenge diri: nabung Rp 10rb/hari',
          'Track spending pakai app (like this one!)',
        ],
      ),
      TipModel(
        id: '4',
        title: 'Zakat 101: Yang Wajib Kamu Tahu',
        description: 'Basics tentang zakat untuk Muslim masa kini',
        category: 'Zakat',
        emoji: '✨',
        tips: [
          'Zakat penghasilan: 2.5% dari gaji',
          'Nisab setara 85 gram emas',
          'Bisa bayar bulanan atau tahunan',
          'Zakat fitrah wajib sebelum Idul Fitri',
        ],
      ),
      TipModel(
        id: '5',
        title: 'Hindari 5 Kesalahan Finansial Ini',
        description: 'Common mistakes yang bikin kantong bolong',
        category: 'Tips',
        emoji: '⚠️',
        tips: [
          'Gak punya emergency fund (min 3-6 bulan gaji)',
          'Beli barang karena FOMO',
          'Gak track pengeluaran',
          'Pakai CC untuk lifestyle',
          'Invest tanpa riset (YOLO investing)',
        ],
      ),
    ];
  }
}

/// RSS Feed source model
class RssFeedSource {
  final String name;
  final String url;
  final String category;

  const RssFeedSource({
    required this.name,
    required this.url,
    required this.category,
  });
}

/// Tip model for curated content
class TipModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String emoji;
  final List<String> tips;

  TipModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.emoji,
    required this.tips,
  });
}
