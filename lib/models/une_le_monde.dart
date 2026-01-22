
import 'package:json_annotation/json_annotation.dart';

part 'une_le_monde.g.dart';

@JsonSerializable()
class Rss {
  Channel channel;

  Rss({required this.channel});

  factory Rss.fromJson(Map<String, dynamic> json) => _$RssFromJson(json);
  Map<String, dynamic> toJson() => _$RssToJson(this);
}

@JsonSerializable()
class Channel {
  List<Item> item;

  Channel({required this.item});

  factory Channel.fromJson(Map<String, dynamic> json) => _$ChannelFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelToJson(this);
}

@JsonSerializable()
class Item {
  String title;
  String link;
  String description;
  String pubDate;
  String guid;

  Item({
    required this.title,
    required this.link,
    required this.description,
    required this.pubDate,
    required this.guid,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
