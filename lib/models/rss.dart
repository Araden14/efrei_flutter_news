import 'package:efrei_flutter_2026/models/channel.dart';

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