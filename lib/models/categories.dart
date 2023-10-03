class Categories {
  final String title;
  final String thumbnail;
  final List<dynamic> keywords;

  Categories({
    required this.title,
    required this.thumbnail,
    required this.keywords,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      title: json["title"],
      thumbnail: json["thumbnail"],
      keywords: json["keywords"],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'thumbnail': thumbnail,
        'keywords': keywords,
      };
}
