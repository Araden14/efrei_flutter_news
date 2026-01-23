import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:efrei_flutter_2026/models/une_le_monde.dart';
import 'package:xml2json/xml2json.dart';

class FetchLeMonde {
  final Dio _dio = Dio();
  final Xml2Json xml2json = Xml2Json();

  Future<Rss<UneLeMonde>> getUne() async {
    try {
      final response = await _dio.get('https://www.lemonde.fr/rss/une.xml');
      xml2json.parse(response.data);
      final json = jsonDecode(xml2json.toParker());
      return Rss<UneLeMonde>.fromJson(
        json['rss'],
        (e) => UneLeMonde.fromJson(e as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception("Erreur chargement Une Le Monde");
    }
  }
}
