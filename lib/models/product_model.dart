class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // support multiple possible field names coming from different APIs
    final id = (json['id'] ?? json['product_id'] ?? json['sku'] ?? '')
        .toString();
    final name = (json['name'] ?? json['title'] ?? json['product_name'] ?? '')
        .toString();
    final description =
        (json['description'] ?? json['desc'] ?? json['details'] ?? '')
            .toString();
    double price = 0.0;
    try {
      final p = json['price'] ?? json['price_usd'] ?? json['amount'];
      if (p is String) price = double.tryParse(p) ?? 0.0;
      if (p is num) price = p.toDouble();
    } catch (_) {}
    final imageUrl =
        (json['image'] ??
                json['imageUrl'] ??
                json['image_url'] ??
                json['thumbnail'] ??
                '')
            .toString();

    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'image': imageUrl,
  };
}
