import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../services/product_service.dart';
import 'detail_screen.dart';

// Enhancement 1: Cart screen and clickable cart items
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _loadingUserCart = false;

  // Enhancement 3: Cart by user ID — load carts from DummyJSON /carts/user/{userId}.
  Future<void> _loadUserCart(int userId) async {
    setState(() => _loadingUserCart = true);
    try {
      final cartCount =
          await context.read<CartProvider>().loadCartsByUser(userId);
      if (!mounted) return;

      final itemCount = context.read<CartProvider>().items.length;
      final message = cartCount == 0
          ? 'No carts found for user $userId'
          : 'Loaded $cartCount cart(s) for user $userId ($itemCount items)';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load cart: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingUserCart = false);
    }
  }

  Future<void> _promptLoadUserCart() async {
    final controller = TextEditingController(
      text: '${CartProvider.defaultUserId}',
    );

    final userId = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Load user cart'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'User ID',
            hintText: 'e.g. 5',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final id = int.tryParse(controller.text.trim());
              if (id == null) return;
              Navigator.pop(context, id);
            },
            child: const Text('Load'),
          ),
        ],
      ),
    );

    controller.dispose();
    if (userId != null) {
      await _loadUserCart(userId);
    }
  }

  // Enhancement 1: Navigate to the existing detail_screen.dart with the Product.
  Future<void> _openProductDetail(Product product) async {
    Product detail = product;
    final id = int.tryParse(product.id);
    if (id != null) {
      try {
        detail = await ProductService.getProductById(id);
      } catch (_) {}
    }
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductScreen(product: detail)),
    );
  }

  int _productId(Product product) => int.tryParse(product.id) ?? 0;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      // Enhancement 2: Chat FloatingActionButton hidden on cart screen.
      floatingActionButton: null,
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: const Color(0xFF4A4E69),
        elevation: 0,
        actions: [
          if (_loadingUserCart)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              tooltip: 'Load user cart',
              icon: const Icon(Icons.cloud_download),
              onPressed: _promptLoadUserCart,
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: cart.isEmpty
          ? Center(
              child: Text(
                cart.loadedUserId == null
                    ? 'Your cart is empty'
                    : 'No items in cart for user ${cart.loadedUserId}',
                style: const TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      final product = item.product;
                      final productId = _productId(product);

                      return GestureDetector(
                        onTap: () => _openProductDetail(product),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.image_not_supported),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.orange.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Qty: ${item.quantity} | Total: \$${item.lineTotal.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  _QtyButton(
                                    icon: Icons.add,
                                    color: Colors.orange,
                                    onPressed: () =>
                                        cart.increaseQuantity(productId),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  _QtyButton(
                                    icon: Icons.remove,
                                    color: Colors.grey.shade300,
                                    iconColor: Colors.black54,
                                    onPressed: () =>
                                        cart.decreaseQuantity(productId),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Subtotal:',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '\$${cart.subtotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Shipping Fee:',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '\$${CartProvider.shippingFee.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${cart.orderTotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Order confirmed!'),
                              ),
                            );
                            cart.clearCart();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Confirm Order',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/settings');
          }
        },
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color? iconColor;
  final VoidCallback onPressed;

  const _QtyButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(icon, color: iconColor ?? Colors.white, size: 18),
        ),
      ),
    );
  }
}
