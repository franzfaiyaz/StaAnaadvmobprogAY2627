import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ProductService {
  static Future<List<Product>> getAllProducts() async {
    final host = dotenv.isInitialized ? dotenv.env['HOST'] : null;

    if (host == null || host.isEmpty) {
      return _sampleProducts();
    }

    try {
      final uri = Uri.parse('$host/products');
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to load products: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      final productsJson = _extractProducts(body);

      return productsJson
          .map<Product>((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw Exception('Failed to load products');
    }
  }

  static List<dynamic> _extractProducts(dynamic body) {
    if (body is List) return body;
    if (body is Map<String, dynamic>) {
      final products = body['products'] ?? body['data'];
      if (products is List) return products;
    }
    throw Exception('Unexpected API response');
  }

  static List<Product> _sampleProducts() {
    return const [
      Product(
        id: '001',
        name: 'Wireless Headphones',
        description:
            'Comfortable over-ear headphones with noise reduction. '
            'Perfect for music lovers and remote workers who need clear audio '
            'and all-day comfort during long listening sessions.',
        price: 89.99,
        imageUrl:
            'https://images.unsplash.com/photo-1512499617640-c2f999018b72?auto=format&fit=crop&w=800&q=80',
      ),
    ];
  }
}
