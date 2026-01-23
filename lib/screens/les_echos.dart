import 'package:efrei_flutter_2026/models/elections_les_echos.dart';
import 'package:efrei_flutter_2026/models/rss.dart';
import 'package:efrei_flutter_2026/services/fetch_les_echos.dart';
import 'package:efrei_flutter_2026/widgets/les_echos_items.dart';
import 'package:flutter/material.dart';

class LesEchosScreen extends StatefulWidget {
  const LesEchosScreen({super.key});

  @override
  State<LesEchosScreen> createState() => _LesEchosScreenState();
}

class _LesEchosScreenState extends State<LesEchosScreen> {
  late Future<Rss<ElectionsLesEchos>> futureRss;

  @override
  void initState() {
    super.initState();
    futureRss = FetchLesEchos().getElections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Le Monde - à la une'),
      ),
      body: Center(
        child: FutureBuilder<Rss<ElectionsLesEchos>>(
          future: futureRss,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: snapshot.data!.channel.item.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data!.channel.item[index];
                    return LesEchosItem(item: item);
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
