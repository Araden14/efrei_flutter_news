class NewsItem {
  final String title;
  final String pubDate;
  final String description;
  final String link;

  NewsItem({required this.title, 
  required this.description, 
  required this.pubDate,
  required this.link
  });

  factory NewsItem.fromJson(Map<String, dynamic> json){
    return NewsItem(title: json["title"], 
    description: json["description"], 
    pubDate: json["pubDate"], 
    link: json["link"]);
  }
}