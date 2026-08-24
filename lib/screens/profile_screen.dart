import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../models/user.dart';
import '../services/cart_service.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  List<Cart> _carts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Enhancement 3: User model, profile rendering, and cart rendering by userId
  Future<void> _loadProfile() async {
    try {
      final userData = await UserService().getUserData();
      final user = User.fromJson(userData);
      final carts = await CartService().getCartsByUser(user.id);

      if (!mounted) return;
      setState(() {
        _user = user;
        _carts = carts;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile failed to load: $e')),
      );
    }
  }

  Future<void> _logout() async {
    await UserService().logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = _user ?? const User(
      id: 0,
      username: '',
      email: '',
      firstName: '',
      lastName: '',
      gender: '',
      image: '',
      accessToken: '',
      refreshToken: '',
    );

    final fullName = [user.firstName, user.lastName]
        .where((value) => value.trim().isNotEmpty)
        .join(' ');

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C3F79),
        foregroundColor: Colors.white,
        title: Text(fullName.isNotEmpty ? fullName : 'Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E9F0),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 52,
                          backgroundColor: Colors.white,
                          backgroundImage: user.image.isNotEmpty
                              ? NetworkImage(user.image)
                              : null,
                          child: user.image.isEmpty
                              ? const Icon(Icons.person, size: 48, color: Color(0xFF1C3F79))
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          fullName.isNotEmpty ? fullName : 'User Profile',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '@${user.username.isNotEmpty ? user.username : 'guest'}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF5A5A5A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _InfoTile(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: user.email.isNotEmpty ? user.email : 'N/A',
                        ),
                        const Divider(height: 1),
                        _InfoTile(
                          icon: Icons.person_outline,
                          label: 'Username',
                          value: user.username.isNotEmpty ? user.username : 'N/A',
                        ),
                        const Divider(height: 1),
                        _InfoTile(
                          icon: Icons.transgender_outlined,
                          label: 'Gender',
                          value: user.gender.isNotEmpty ? user.gender : 'N/A',
                        ),
                        const Divider(height: 1),
                        _InfoTile(
                          icon: Icons.badge_outlined,
                          label: 'User ID',
                          value: user.id != 0 ? '#${user.id}' : '#000',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_carts.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Cart Summary',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'User cart ID: ${_carts.first.id}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Products: ${_carts.first.totalProducts}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Total quantity: ${_carts.first.totalQuantity}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'No saved cart data for this user.',
                        style: TextStyle(fontSize: 14, color: Color(0xFF5A5A5A)),
                      ),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Log Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF26C5E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1C3F79),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/cart');
          }
        },
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFD6A228)),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4E4E4E),
                  ),
                ),
                Flexible(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
