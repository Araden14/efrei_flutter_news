import 'package:efrei_flutter_2026/screens/le_monde.dart';
import 'package:efrei_flutter_2026/screens/les_echos.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Le Monde RSS',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Client RSS'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LeMondeScreen(),
                  ),
                );
              },
              child: const Text('Voir Le Monde - à la une'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LesEchosScreen(),
                  ),
                );
              },
              child: const Text('Voir Les Echos - Elections'),
            ),
          ],
        ),
      ),
    );
  }
}
