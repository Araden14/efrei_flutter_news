import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(const NewsApp());
}

// ========== MODÈLE DE DONNÉES ==========
class NewsArticle {
  final String title;
  final String description;
  final String link;
  final DateTime? publishedAt;
  final String? imageUrl;
  final String? source;

  NewsArticle({
    required this.title,
    required this.description,
    required this.link,
    this.publishedAt,
    this.imageUrl,
    this.source,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: (json['title'] ?? 'Sans titre').toString(),
      description: (json['description'] ?? '').toString(),
      link: (json['url'] ?? '').toString(),
      imageUrl: json['image']?.toString(),
      source: json['source']?.toString(),
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'].toString())
          : null,
    );
  }
}

// ========== SERVICE MEDIASTACK ==========
class NewsService {
  static const String _apiKey = '5e616923038bbf78cf4e150d9f8f1f7c';
  static const String _baseUrl = 'http://api.mediastack.com/v1/news';

  static Future<List<NewsArticle>> fetchArticles({
    required String category,
    String languages = 'fr',
    int limit = 25,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl?access_key=$_apiKey&categories=$category&languages=$languages&limit=$limit',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Erreur HTTP ${response.statusCode}');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;

    // Mediastack renvoie "error" dans le body si pb de clé/plan/etc.
    if (data['error'] != null) {
      final err = data['error'];
      throw Exception('Erreur API: ${err['message'] ?? err.toString()}');
    }

    final list = (data['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(NewsArticle.fromJson)
        .where((a) => a.link.isNotEmpty)
        .toList();

    return list;
  }
}

// ========== APP ==========
class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blueGrey),
      home: const NewsHomePage(),
    );
  }
}

// ========== PAGE PRINCIPALE ==========
class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  // Catégories Mediastack (quelques-unes)
  final Map<String, String> _categories = {
    'Général': 'general',
    'Business': 'business',
    'Sport': 'sports',
    'Tech': 'technology',
    'Santé': 'health',
    'Science': 'science',
    'Divertissement': 'entertainment',
  };

  late String _selectedCategoryName;
  late Future<List<NewsArticle>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _selectedCategoryName = _categories.keys.first;
    _articlesFuture = _load();
  }

  Future<List<NewsArticle>> _load() {
    final cat = _categories[_selectedCategoryName]!;
    return NewsService.fetchArticles(category: cat, languages: 'fr', limit: 25);
  }

  void _changeCategory(String name) {
    setState(() {
      _selectedCategoryName = name;
      _articlesFuture = _load();
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _articlesFuture = _load();
    });
    await _articlesFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mediastack • $_selectedCategoryName'),
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
                padding: const EdgeInsets.all(18),
                child: Text(
                  'Erreur : ${snapshot.error}\n\n'
                  'Si tu es sur Web: Mediastack gratuit est souvent en HTTP => bloqué.\n'
                  'Teste sur Android (émulateur) pour être tranquille.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final articles = snapshot.data ?? [];
          if (articles.isEmpty) {
            return const Center(child: Text('Aucun article trouvé'));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return ArticleCard(article: articles[index]);
              },
            ),
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
            if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.source != null && article.source!.isNotEmpty)
                    Text(
                      article.source!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (article.description.isNotEmpty)
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
                        article.publishedAt != null
                            ? DateFormat('dd MMM yyyy • HH:mm', 'fr_FR')
                                .format(article.publishedAt!.toLocal())
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