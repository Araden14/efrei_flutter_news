import 'package:json_annotation/json_annotation.dart';

part 'une_le_monde.g.dart';

// @JsonSerializable()
// class Rss {
//   Channel channel;

//   Rss({required this.channel});

//   factory Rss.fromJson(Map<String, dynamic> json) => _$RssFromJson(json);
//   Map<String, dynamic> toJson() => _$RssToJson(this);
// }

@JsonSerializable()
class Rss<T> {
  Channel<T> channel;

  Rss({required this.channel});

  factory Rss.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$RssFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$RssToJson(this, toJsonT);
}

@JsonSerializable(genericArgumentFactories: true)
class Channel<T> {
  List<T> item;

  Channel({required this.item});

  factory Channel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ChannelFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ChannelToJson(this, toJsonT);
}

// abstract class Item {
//   // Common properties or methods if any, otherwise just an empty abstract class
// }

// @JsonSerializable()
// class UneLeMonde implements Item {
//   String title;
//   String link;
//   String description;
//   String pubDate;
//   String guid;

//   List<Item> item;

//   Channel({required this.item});

//   factory Channel.fromJson(Map<String, dynamic> json) =>
//       _$ChannelFromJson(json);
//   Map<String, dynamic> toJson() => _$ChannelToJson(this);
// }

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
      _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
