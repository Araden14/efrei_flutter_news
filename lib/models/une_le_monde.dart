import 'package:json_annotation/json_annotation.dart';

part 'une_le_monde.g.dart';

// @JsonSerializable()
// class Rss {
//   Channel channel;

//   Rss({required this.channel});

//   factory Rss.fromJson(Map<String, dynamic> json) => _$RssFromJson(json);
//   Map<String, dynamic> toJson() => _$RssToJson(this);
// }

// @JsonSerializable()
class Rss<T> {
  Channel<T> channel;

  Rss({required this.channel});

  factory Rss.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return Rss<T>(
      channel: Channel<T>.fromJson(
        json['channel'] as Map<String, dynamic>,
        fromJsonT,
      ),
    );
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      <String, dynamic>{'channel': channel.toJson(toJsonT)};
}

class Channel<T> {
  List<T> item;

  Channel({required this.item});

  factory Channel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final itemsJson = json['item'] as List<dynamic>? ?? [];
    return Channel<T>(item: itemsJson.map((e) => fromJsonT(e)).toList());
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      <String, dynamic>{'item': item.map((e) => toJsonT(e)).toList()};
}

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
