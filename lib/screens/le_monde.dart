import 'package:efrei_flutter_2026/models/rss.dart';
import 'package:efrei_flutter_2026/models/une_le_monde.dart';
import 'package:efrei_flutter_2026/services/fetch_le_monde.dart';
import 'package:efrei_flutter_2026/widgets/le_monde_items.dart';
import 'package:flutter/material.dart';

class LeMondeScreen extends StatefulWidget {
  const LeMondeScreen({super.key});

  @override
  State<LeMondeScreen> createState() => _LeMondeScreenState();
}

class _LeMondeScreenState extends State<LeMondeScreen> {
  late Future<Rss<UneLeMonde>> futureRss;

  @override
  void initState() {
    super.initState();
    futureRss = FetchLeMonde().getUne();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Le Monde - à la une'),
      ),
      body: Center(
        child: FutureBuilder<Rss<UneLeMonde>>(
          future: futureRss,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: snapshot.data!.channel.item.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data!.channel.item[index];
                    return LeMondeItem(item: item);
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
