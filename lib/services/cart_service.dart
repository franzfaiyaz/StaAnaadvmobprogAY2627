import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/cart.dart';

class CartService {
  String get _host => host;

  // Enhancement 3: Cart by user ID and Add to Cart API
  Future<List<Cart>> getAllCarts() async {
    final response = await http.get(Uri.parse('$_host/carts'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load carts: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final cartsJson = data['carts'] as List? ?? [];
    return cartsJson
        .map((json) => Cart.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Enhancement 3: GET /carts/{id}
  Future<Cart> getCartById(int id) async {
    final response = await http.get(Uri.parse('$_host/carts/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load cart $id: ${response.statusCode}');
    }

    return Cart.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  // Enhancement 3: GET /carts/user/{userId}
  // Response shape: { "carts": [ Cart, ... ], "total": n, "skip": 0, "limit": n }
  Future<List<Cart>> getCartsByUser(int userId) async {
    final response = await http.get(Uri.parse('$_host/carts/user/$userId'));
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load carts for user $userId: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final cartsJson = data['carts'] as List? ?? [];
    return cartsJson
        .map((json) => Cart.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Enhancement 3: POST /carts/add
  Future<Cart> addCart({
    required int userId,
    required int productId,
    required int quantity,
  }) async {
    final response = await http.post(
      Uri.parse('$_host/carts/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'products': [
          {'id': productId, 'quantity': quantity},
        ],
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add cart: ${response.statusCode}');
    }

    return Cart.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
