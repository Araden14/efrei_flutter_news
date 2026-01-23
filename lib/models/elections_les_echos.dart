import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ElectionsLesEchos {
  String title;
  String description;
  String link;
  String pubDate;

  ElectionsLesEchos({
    required this.title,
    required this.description,
    required this.link,
    required this.pubDate,
  });

  factory ElectionsLesEchos.fromJson(Map<String, dynamic> json) =>
      _$ElectionsLesEchosFromJson(json);
  Map<String, dynamic> toJson() => _$ElectionsLesEchosToJson(this);

  static ElectionsLesEchos _$ElectionsLesEchosFromJson(
    Map<String, dynamic> json,
  ) {
    return ElectionsLesEchos(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      link: json['link'] as String? ?? '',
      pubDate: json['pubDate'] as String? ?? '',
    );
  }

  static Map<String, dynamic> _$ElectionsLesEchosToJson(
    ElectionsLesEchos instance,
  ) => <String, dynamic>{
    'title': instance.title,
    'description': instance.description,
    'link': instance.link,
    'pubDate': instance.pubDate,
  };
}
