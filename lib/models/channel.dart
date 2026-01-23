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
