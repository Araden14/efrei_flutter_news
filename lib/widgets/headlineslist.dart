import 'package:efrei_flutter_news/services/lemonde.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const _months = {
  'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
  'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
};

DateTime? parsePubDate(String pubDate) {
  try {
    final parts = pubDate.split(' ');
    final day = int.parse(parts[1]);
    final month = _months[parts[2]]!;
    final year = int.parse(parts[3]);
    final timeParts = parts[4].split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final second = int.parse(timeParts[2]);
    return DateTime.utc(year, month, day, hour, minute, second);
  } catch (e) {
    return null;
  }
}

String formatRelativeTime(String pubDate) {
  final date = parsePubDate(pubDate);
  if (date == null) return pubDate;

  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays > 0) {
    return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
  } else if (difference.inHours > 0) {
    return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
  } else if (difference.inMinutes > 0) {
    return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
  } else {
    return 'À l\'instant';
  }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
class LeMondeHeadlines extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Le Monde Headlines')),
      body: FutureBuilder<List<dynamic>>(
        future: HeadLinesLeMonde(),
        builder: (context, snapshot) {
          // 1. Check if the data is still loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } 
          
          // 2. Check if an error occurred
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // 3. Data has arrived successfully
          else {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(items[index].title, style: TextStyle(fontWeight: FontWeight.bold)),
                leading: Column(children: [Icon(Icons.article), Text(formatRelativeTime(items[index].pubDate))],),
                subtitle: Text(items[index].description),
                // navigate to link on tap
                trailing:  IconButton(onPressed: () {
                  _launchUrl(items[index].link);
                }, icon: Icon(Icons.open_in_new))
              ),
            );
          }
        },
      ),
    );
  }
}