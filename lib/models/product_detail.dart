class ProductD {
  final String id;
  final String title;
  final String thumbnail;
  final int mrpAmount;
  final int ourAmount;
  final String brand;
  final bool isVeg;
  final List<dynamic> keywords;

  final List<dynamic> description;
  final List<dynamic> information;
  final List<dynamic> feature;
  final List<dynamic> images;

  ProductD(
      {required this.id,
      required this.title,
      required this.thumbnail,
      required this.mrpAmount,
      required this.ourAmount,
      required this.brand,
      required this.isVeg,
      required this.keywords,
      required this.description,
      required this.information,
      required this.feature,
      required this.images});

  factory ProductD.fromJson(Map<String, dynamic> json) {
    return ProductD(
      id: json["_id"],
      title: json["title"],
      thumbnail: json["thumbnail"],
      mrpAmount: json["mrpAmount"],
      ourAmount: json["ourAmount"],
      brand: json["brand"],
      isVeg: json["isVeg"],
      keywords: json["keywords"],
      description: json["description"],
      information: json["information"],
      feature: json["feature"],
      images: json['images'],
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
        'description': description,
        'information': information,
        'feature': feature,
        'images': images,
      };
}
