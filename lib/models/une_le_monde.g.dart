// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'une_le_monde.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rss _$RssFromJson(Map<String, dynamic> json) =>
    Rss(channel: Channel.fromJson(json['channel'] as Map<String, dynamic>));

Map<String, dynamic> _$RssToJson(Rss instance) => <String, dynamic>{
  'channel': instance.channel,
};

Channel _$ChannelFromJson(Map<String, dynamic> json) => Channel(
  item: (json['item'] as List<dynamic>)
      .map((e) => Item.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
  'item': instance.item,
};

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
  title: json['title'] as String,
  link: json['link'] as String,
  description: json['description'] as String,
  pubDate: json['pubDate'] as String,
  guid: json['guid'] as String,
);

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
  'title': instance.title,
  'link': instance.link,
  'description': instance.description,
  'pubDate': instance.pubDate,
  'guid': instance.guid,
};
