class Product {
  final String id;
  final String categoryId;
  final String name;
  final double price;
  final String imageUrl;
  final String? description;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String,
      description: json['description'] as String?,
    );
  }
}
