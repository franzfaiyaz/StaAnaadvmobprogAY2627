import 'product_model.dart';

class ProductService {
  static List<Product> getProducts() {
    return const [
      Product(
        id: '001',
        name: 'Wireless Headphones',
        description: 'Comfortable over-ear headphones with noise reduction.',
        price: 89.99,
        imageUrl:
            'https://images.unsplash.com/photo-1512499617640-c2f999018b72?auto=format&fit=crop&w=800&q=80',
      ),
      Product(
        id: '002',
        name: 'Smart Speaker',
        description:
            'Voice-enabled speaker with rich sound and smart home control.',
        price: 69.50,
        imageUrl:
            'https://images.unsplash.com/photo-1581276879432-15a19d654956?auto=format&fit=crop&w=800&q=80',
      ),
      Product(
        id: '003',
        name: 'Fitness Tracker',
        description: 'Keep track of your workouts, heart rate, and sleep data.',
        price: 49.99,
        imageUrl:
            'https://images.unsplash.com/photo-1516574187841-cb9cc2ca948b?auto=format&fit=crop&w=800&q=80',
      ),
    ];
  }
}
