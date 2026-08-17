import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:staana_advmobprog/providers/cart_provider.dart';
import 'package:staana_advmobprog/providers/theme_provider.dart';

void main() {
  testWidgets('CartProvider starts empty', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
        ],
        child: const MaterialApp(home: Scaffold(body: Text('Test'))),
      ),
    );

    final cartProvider = tester
        .element(find.text('Test'))
        .read<CartProvider>();

    expect(cartProvider.isEmpty, isTrue);
    expect(cartProvider.totalQuantity, 0);
    expect(cartProvider.subtotal, 0.0);
  });
}
