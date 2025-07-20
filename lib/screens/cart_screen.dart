// lib/screens/cart_screen.dart
import 'package:flutter/material.dart' hide Badge;
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/providers/cart_provider.dart';
import 'package:smart_shop/widgets/app_drawer.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProv = context.watch<CartProvider>();
    final items = cartProv.items;
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart', style: tt.headlineSmall),
        actions: [
          IconButton(
            tooltip: 'Items in cart',
            onPressed: () {},
            icon: Badge(
              position: BadgePosition.topEnd(top: -4, end: -6),
              badgeColor: theme.colorScheme.error,
              animationType: BadgeAnimationType.scale,
              badgeContent: Text(
                cartProv.count.toString(),
                style: tt.bodySmall?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                color: theme.iconTheme.color,
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: items.isEmpty
          ? Center(child: Text('Your cart is empty', style: tt.bodyLarge))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final ci = items[i];
                      final p = ci.product;
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  p.image,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.title,
                                        style: tt.titleMedium,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 6),
                                    Text('\$${p.price.toStringAsFixed(2)}',
                                        style: tt.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const SizedBox(height: 6),
                                    Text('Qty: ${ci.quantity}',
                                        style: tt.bodyMedium),
                                  ],
                                ),
                              ),
                              // + / − buttons
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    color: theme.colorScheme.primary,
                                    onPressed: () =>
                                        cartProv.add(p),
                                  ),
                                  IconButton(
                                    icon:
                                        const Icon(Icons.remove_circle_outline),
                                    color: theme.colorScheme.error,
                                    onPressed: () =>
                                        cartProv.removeSingle(p.id),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_outline,
                                    color: theme.colorScheme.error),
                                onPressed: () =>
                                    cartProv.remove(p.id),
                                tooltip: 'Remove item',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Summary & Checkout
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, -2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Items: ${cartProv.count}', style: tt.bodyLarge),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('Total:', style: tt.headlineMedium),
                          const Spacer(),
                          Text('\$${cartProv.total.toStringAsFixed(2)}',
                              style: tt.headlineMedium),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/checkout'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: tt.labelLarge,
                        ),
                        child: Text(
                          'Checkout (${cartProv.count} items)',
                          style: tt.labelLarge,
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
