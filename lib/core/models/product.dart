class Product {
  final String id;
  final String name;
  final double price;
  final double? oldPrice; // Prix avant réduction, null si pas de réduction
  final String imageUrl;
  final String category;
  final double rating;
  final int ratingCount;
  final bool isFavorite;
  final bool isOnSale;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    required this.category,
    this.rating = 0.0,
    this.ratingCount = 0,
    this.isFavorite = false,
    this.isOnSale = false,
  });

  // Factory constructor pour créer un produit à partir de JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      oldPrice: json['oldPrice']?.toDouble(),
      imageUrl: json['imageUrl'],
      category: json['category'],
      rating: json['rating']?.toDouble() ?? 0.0,
      ratingCount: json['ratingCount'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
      isOnSale: json['isOnSale'] ?? false,
    );
  }

  // Convertir un produit en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'oldPrice': oldPrice,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'ratingCount': ratingCount,
      'isFavorite': isFavorite,
      'isOnSale': isOnSale,
    };
  }

  // Calculer le pourcentage de réduction si applicable
  double? getDiscountPercentage() {
    if (oldPrice != null && oldPrice! > price) {
      return ((oldPrice! - price) / oldPrice! * 100).roundToDouble();
    }
    return null;
  }

  // Créer une copie d'un produit avec des paramètres modifiés
  Product copyWith({
    String? id,
    String? name,
    double? price,
    double? oldPrice,
    String? imageUrl,
    String? category,
    double? rating,
    int? ratingCount,
    bool? isFavorite,
    bool? isOnSale,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      isFavorite: isFavorite ?? this.isFavorite,
      isOnSale: isOnSale ?? this.isOnSale,
    );
  }
}
