// lib/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:smart_shop/providers/cart_provider.dart';

class CheckoutScreen extends StatelessWidget {
  static const routeName = '/checkout';
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;
    final total = cart.total;
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final slideKey = GlobalKey<SlideActionState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: tt.headlineMedium),
      ),
      body: Column(
        children: [
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text('Your cart is empty', style: tt.bodyMedium),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, i) {
                      final ci = items[i];
                      final p = ci.product;
                      final lineTotal = p.price * ci.quantity;
                      return ListTile(
                        leading: Image.network(
                          p.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          p.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tt.titleMedium,
                        ),
                        subtitle: Text(
                          '${ci.quantity} × \$${p.price.toStringAsFixed(2)}',
                          style: tt.bodyMedium,
                        ),
                        trailing: Text(
                          '\$${lineTotal.toStringAsFixed(2)}',
                          style: tt.titleMedium,
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Total', style: tt.titleLarge),
                const SizedBox(height: 4),
                Text('\$${total.toStringAsFixed(2)}', style: tt.headlineMedium),
                const SizedBox(height: 16),
                SlideAction(
                  key: slideKey,
                  text: 'Slide to Pay',
                  textStyle: tt.titleMedium?.copyWith(color: Colors.white),
                  innerColor: theme.colorScheme.primary,
                  outerColor: theme.colorScheme.primary.withOpacity(0.2),
                  sliderButtonIcon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onSubmit: () {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      cart.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order placed!')),
                      );
                      slideKey.currentState?.reset();
                      Navigator.popUntil(
                          context, ModalRoute.withName('/home'));
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
