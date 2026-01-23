import 'package:json_annotation/json_annotation.dart';

part 'une_le_monde.g.dart';

@JsonSerializable()
class UneLeMonde {
  String title;
  String link;
  String description;
  String pubDate;
  String guid;

  UneLeMonde({
    required this.title,
    required this.link,
    required this.description,
    required this.pubDate,
    required this.guid,
  });

  factory UneLeMonde.fromJson(Map<String, dynamic> json) =>
      _$UneLeMondeFromJson(json);
  Map<String, dynamic> toJson() => _$UneLeMondeToJson(this);

  static UneLeMonde _$UneLeMondeFromJson(Map<String, dynamic> json) {
    return UneLeMonde(
      title: json['title'] as String? ?? '',
      link: json['link'] as String? ?? '',
      description: json['description'] as String? ?? '',
      pubDate: json['pubDate'] as String? ?? '',
      guid: json['guid'] as String? ?? '',
    );
  }

  static Map<String, dynamic> _$UneLeMondeToJson(UneLeMonde instance) =>
      <String, dynamic>{
        'title': instance.title,
        'link': instance.link,
        'description': instance.description,
        'pubDate': instance.pubDate,
        'guid': instance.guid,
      };
}
