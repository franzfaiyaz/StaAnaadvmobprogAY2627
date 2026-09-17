import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/product_model.dart';

class ProductService {
  static String get _host => host;

  static Future<List<Product>> getAllProducts() async {
    final uri = Uri.parse('$_host/products');
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Failed to load products: ${response.statusCode}');
    }

    final body = jsonDecode(response.body);
    final productsJson = _extractProducts(body);

    return productsJson
        .map<Product>((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static Future<Product> getProductById(int id) async {
    final uri = Uri.parse('$_host/products/$id');
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Failed to load product $id: ${response.statusCode}');
    }

    return Product.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  static List<dynamic> _extractProducts(dynamic body) {
    if (body is List) return body;
    if (body is Map<String, dynamic>) {
      final products = body['products'] ?? body['data'];
      if (products is List) return products;
    }
    throw Exception('Unexpected API response');
  }
}
