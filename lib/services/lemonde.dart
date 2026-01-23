import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:efrei_flutter_news/models/lemonde.dart';
import 'package:xml2json/xml2json.dart';

final dio = Dio();
final xmlparser = Xml2Json();
Future<List<NewsItem>> HeadLinesLeMonde() async {
  final response = await dio.get(
        'https://api.allorigins.win/raw?url=${Uri.encodeComponent('https://www.lemonde.fr/rss/une.xml')}',
      );
  final articles = <NewsItem>[];
  var xml = response.data.toString();
  xmlparser.parse(xml);
  var jsonString = xmlparser.toOpenRally();
  Map<String, dynamic> data = jsonDecode(jsonString);
  // Assuming 'data' is the variable containing your Map
  var items = data['rss']['channel']['item'];

  if (items is List) {
    for (var article in items) {
      final item = NewsItem.fromJson(article);
      articles.add(item);
    }
  } else {
    final item = NewsItem.fromJson(items);
    articles.add(item);
  }
  return articles;
}