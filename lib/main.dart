import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(const LeMondeApp());
}

// ========== MODÈLE DE DONNÉES ==========
class NewsArticle {
  final String title;
  final String description;
  final String link;
  final DateTime? pubDate;
  final String? imageUrl;

  NewsArticle({
    required this.title,
    required this.description,
    required this.link,
    this.pubDate,
    this.imageUrl,
  });

  // Parse depuis un élément XML <item>
  factory NewsArticle.fromXml(xml.XmlElement item) {
    String getTextOrEmpty(String tag) {
      return item.findElements(tag).isNotEmpty
          ? item.findElements(tag).first.innerText
          : '';
    }

    // Récupération de l'image (media:content)
    String? imageUrl;
    final mediaContent = item.findElements('media:content');
    if (mediaContent.isNotEmpty) {
      imageUrl = mediaContent.first.getAttribute('url');
    }

    // Parse de la date
    DateTime? pubDate;
    final pubDateStr = getTextOrEmpty('pubDate');
    if (pubDateStr.isNotEmpty) {
      try {
        pubDate = DateFormat('EEE, dd MMM yyyy HH:mm:ss Z', 'en_US')
            .parse(pubDateStr);
      } catch (_) {}
    }

    return NewsArticle(
      title: getTextOrEmpty('title').trim(),
      description: getTextOrEmpty('description').trim(),
      link: getTextOrEmpty('link').trim(),
      pubDate: pubDate,
      imageUrl: imageUrl,
    );
  }
}

// ========== SERVICE RSS ==========
class RssService {
  static Future<List<NewsArticle>> fetchArticles(String rssUrl) async {
    final response = await http.get(
      Uri.parse(rssUrl),
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur HTTP ${response.statusCode}');
    }

    final body = utf8.decode(response.bodyBytes);
    final document = xml.XmlDocument.parse(body);
    final items = document.findAllElements('item');

    return items.map((item) => NewsArticle.fromXml(item)).toList();
  }
}

// ========== APP ==========
class LeMondeApp extends StatelessWidget {
  const LeMondeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
      ),
      home: const RssHomePage(),
    );
  }
}

// ========== PAGE PRINCIPALE ==========
class RssHomePage extends StatefulWidget {
  const RssHomePage({super.key});

  @override
  State<RssHomePage> createState() => _RssHomePageState();
}

class _RssHomePageState extends State<RssHomePage> {
  final Map<String, String> _categories = {
    'À la une': 'https://www.lemonde.fr/rss/une.xml',
    'International': 'https://www.lemonde.fr/international/rss_full.xml',
    'Sport': 'https://www.lemonde.fr/sport/rss_full.xml',
    'Économie': 'https://www.lemonde.fr/economie/rss_full.xml',
    'Politique': 'https://www.lemonde.fr/politique/rss_full.xml',
    'Brésil': 'https://www.lemonde.fr/bresil/rss_full.xml',
    'Planète': 'https://www.lemonde.fr/planete/rss_full.xml',
    'Culture': 'https://www.lemonde.fr/culture/rss_full.xml',
  };

  late String _selectedCategory;
  late Future<List<NewsArticle>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _selectedCategory = _categories.keys.first;
    _articlesFuture = RssService.fetchArticles(_categories[_selectedCategory]!);
  }

  void _changeCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _articlesFuture = RssService.fetchArticles(_categories[category]!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Le Monde • $_selectedCategory'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _changeCategory,
            itemBuilder: (context) => _categories.keys
                .map((cat) => PopupMenuItem(value: cat, child: Text(cat)))
                .toList(),
          ),
        ],
      ),
      body: FutureBuilder<List<NewsArticle>>(
        future: _articlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Erreur : ${snapshot.error}\n\n'
                  'Sur Chrome/Web, CORS bloque les requêtes.\n'
                  'Lance sur Android/iOS/macOS pour que ça fonctionne.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final articles = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return ArticleCard(article: article);
            },
          );
        },
      ),
    );
  }
}

// ========== CARTE ARTICLE ==========
class ArticleCard extends StatelessWidget {
  final NewsArticle article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openArticle(article.link),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image (si disponible)
            if (article.imageUrl != null)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  article.imageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),

            // Contenu
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    article.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        article.pubDate != null
                            ? DateFormat('dd MMM yyyy • HH:mm', 'fr_FR')
                                .format(article.pubDate!)
                            : '',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openArticle(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Impossible d'ouvrir l'article");
    }
  }
}