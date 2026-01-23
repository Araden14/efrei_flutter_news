// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'une_le_monde.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UneLeMonde _$UneLeMondeFromJson(Map<String, dynamic> json) => UneLeMonde(
  title: json['title'] as String,
  link: json['link'] as String,
  description: json['description'] as String,
  pubDate: json['pubDate'] as String,
  guid: json['guid'] as String,
);

Map<String, dynamic> _$UneLeMondeToJson(UneLeMonde instance) =>
    <String, dynamic>{
      'title': instance.title,
      'link': instance.link,
      'description': instance.description,
      'pubDate': instance.pubDate,
      'guid': instance.guid,
    };
