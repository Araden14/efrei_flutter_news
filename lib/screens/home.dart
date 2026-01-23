import '../widgets/headlineslist.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Efrei Flutter News'),
      ),
      body: Column(
        children: [
          ElevatedButton.icon(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LeMondeHeadlines()),
            );
          }, icon: Icon(Icons.article), label: Text('Le monde - la une')),  
        ],
      ),
    );
  }
}