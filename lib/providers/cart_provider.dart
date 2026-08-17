import 'package:flutter/foundation.dart';

import '../models/cart.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';

class LocalCartItem {
  final Product product;
  int quantity;

  LocalCartItem({required this.product, required this.quantity});

  double get lineTotal => product.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();
  final List<LocalCartItem> _items = [];

  static const int defaultUserId = 1;

  int? _loadedUserId;

  int? get loadedUserId => _loadedUserId;

  List<LocalCartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.lineTotal);

  static const double shippingFee = 5.0;

  double get orderTotal => subtotal + (isEmpty ? 0 : shippingFee);

  int _productKey(Product product) => int.tryParse(product.id) ?? 0;

  LocalCartItem? _findItemById(int productId) {
    for (final item in _items) {
      if (_productKey(item.product) == productId) return item;
    }
    return null;
  }

  LocalCartItem? _findItem(Product product) => _findItemById(_productKey(product));

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    final existing = _findItem(product);
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _items.add(LocalCartItem(product: product, quantity: quantity));
    }
    notifyListeners();

    // Enhancement 3: Cart by user ID and Add to Cart API
    // POST /carts/add is mock — local Provider cart remains the source of truth.
    try {
      await _cartService.addCart(
        userId: defaultUserId,
        productId: _productKey(product),
        quantity: quantity,
      );
    } catch (e) {
      debugPrint('addCart API error (local cart unchanged): $e');
    }
  }

  void increaseQuantity(int productId) {
    final existing = _findItemById(productId);
    if (existing != null) {
      existing.quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(int productId) {
    final existing = _findItemById(productId);
    if (existing == null) return;

    existing.quantity--;
    if (existing.quantity <= 0) {
      _items.remove(existing);
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _items.removeWhere((item) => _productKey(item.product) == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Enhancement 3: Cart by user ID and Add to Cart API
  // Merges products from every cart returned for the user.
  Future<int> loadCartsByUser(int userId) async {
    final carts = await _cartService.getCartsByUser(userId);

    _loadedUserId = userId;
    _items.clear();

    for (final cart in carts) {
      for (final cartProduct in cart.products) {
        final product = _productFromCartProduct(cartProduct);
        final existing = _findItem(product);
        if (existing != null) {
          existing.quantity += cartProduct.quantity;
        } else {
          _items.add(
            LocalCartItem(product: product, quantity: cartProduct.quantity),
          );
        }
      }
    }

    notifyListeners();
    return carts.length;
  }

  Product _productFromCartProduct(CartProduct cartProduct) {
    return Product(
      id: cartProduct.id.toString(),
      name: cartProduct.title,
      description: '',
      price: cartProduct.price,
      imageUrl: cartProduct.thumbnail,
    );
  }
}
