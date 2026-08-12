import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/product_model.dart';

class ProductService {
  // Attempts to fetch products from $host/products. If HOST is not set or
  // the request fails, falls back to a local static list to preserve behavior.
  static Future<List<Product>> getAllProducts() async {
    String? host;
    try {
      if (dotenv.isInitialized) {
        host = dotenv.env['HOST'];
      }
    } catch (e) {
      host = null;
    }
    // ignore: avoid_print
    print('ProductService: host=${host ?? "<null>"}');
    if (host == null || host.isEmpty) {
      // The official API HOST is not yet provided. Keep this temporary local source
      // so the app can display the required sample products until the real host
      // is supplied by the instructor/classmate.
      // Do not treat this as the API response.
      return Future.value(_staticProducts());
    }

    try {
      final uri = Uri.parse('$host/products');
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List productsJson = data['products'] ?? data['data'] ?? [];
        return productsJson
            .map<Product>((j) => Product.fromJson(j as Map<String, dynamic>))
            .toList();
      } else {
        return _staticProducts();
      }
    } catch (e) {
      // ignore: avoid_print
      print('ProductService fetch error: $e');
      return _staticProducts();
    }
  }

  // Local fallback data (keeps existing behavior when HOST is not configured)
  static List<Product> _staticProducts() {
    return const [
      Product(
        id: '001',
        name: 'Wireless Headphones',
        description: 'Comfortable over-ear headphones with noise reduction.',
        price: 89.99,
        imageUrl:
            'https://b6abf2cafabdf2411ea7-feef740dc03bd45ca5c4c88855bb7925.ssl.cf3.rackcdn.com/images/product-images/01_WH-1000XM6_hero_silver_1500_1500.jpg',
      ),
      Product(
        id: '002',
        name: 'Smart Speaker',
        description:
            'Voice-enabled speaker with rich sound and smart home control.',
        price: 69.50,
        imageUrl:
            'https://www.edgars.co.za/cdn/shop/files/3_1870348e-7d85-45ce-b4ee-85b57ba45440.png?v=1764768538&width=720',
      ),
      Product(
        id: '003',
        name: 'Fitness Tracker',
        description: 'Keep track of your workouts, heart rate, and sleep data.',
        price: 49.99,
        imageUrl:
            'https://pyxis.nymag.com/v1/imgs/921/c0c/d56eeaa21522d8918ee1cedde9dea91293.rsquare.w600.jpg',
      ),
    ];
  }
}
