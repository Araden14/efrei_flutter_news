import 'package:efrei_flutter_2026/models/une_le_monde.dart';
import 'package:flutter/material.dart';

class LeMondeItem extends StatelessWidget {
  final UneLeMonde item;

  const LeMondeItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      subtitle: Text(item.description),
      onTap: () {
        // You can add navigation to detail page here if needed
      },
    );
  }
}
