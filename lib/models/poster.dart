class Poster {
  final String thumbnail;
  final List<dynamic>? keywords;
  final String? type;
  final int? height;

  Poster({
    this.type,
    required this.thumbnail,
    this.keywords,
    this.height,
  });

  factory Poster.fromJson(Map<String, dynamic> json) {
    return Poster(
      type: json["type"],
      thumbnail: json["thumbnail"],
      keywords: json["keywords"],
      height: json["height"],
    );
  }

  Map<String, dynamic> toJson() => {
        'height': height,
        'type': type,
        'thumbnail': thumbnail,
        'keywords': keywords,
      };
}
