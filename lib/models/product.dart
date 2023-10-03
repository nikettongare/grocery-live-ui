class Product {
  final String id;
  final String title;
  final String thumbnail;
  final int mrpAmount;
  final int ourAmount;
  final String brand;
  final bool isVeg;
  final List<dynamic> keywords;

  Product({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.mrpAmount,
    required this.ourAmount,
    required this.brand,
    required this.isVeg,
    required this.keywords,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["_id"],
      title: json["title"],
      thumbnail: json["thumbnail"],
      mrpAmount: json["mrpAmount"],
      ourAmount: json["ourAmount"],
      brand: json["brand"],
      isVeg: json["isVeg"],
      keywords: json["keywords"],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'thumbnail': thumbnail,
        'mrpAmount': mrpAmount,
        'ourAmount': ourAmount,
        'brand': brand,
        'isVeg': isVeg,
        'keywords': keywords,
      };
}
