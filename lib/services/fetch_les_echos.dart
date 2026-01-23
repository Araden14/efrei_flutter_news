import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:efrei_flutter_2026/models/elections_les_echos.dart';
import 'package:efrei_flutter_2026/models/rss.dart';
import 'package:xml2json/xml2json.dart';

class FetchLesEchos {
  final Dio _dio = Dio();
  final Xml2Json xml2json = Xml2Json();

  Future<Rss<ElectionsLesEchos>> getElections() async {
    try {
      final response = await _dio.get('https://services.lesechos.fr/rss/elections.xml');
      xml2json.parse(response.data);
      final json = jsonDecode(xml2json.toParker());
      return Rss<ElectionsLesEchos>.fromJson(
        json['rss'],
        (e) => ElectionsLesEchos.fromJson(e as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception("Erreur chargement Une Le Monde");
    }
  }
}
