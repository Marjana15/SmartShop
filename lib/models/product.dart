// lib/models/product.dart
class Product {
  final int id;
  final String title, description, image, category;
  final double price;
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.category,
    required this.price,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> j) {
    return Product(
      id: j['id'],
      title: j['title'],
      description: j['description'],
      image: j['image'],
      category: j['category'],
      price: (j['price'] as num).toDouble(),
      rating: (j['rating']['rate'] as num).toDouble(),
    );
  }
}
