// lib/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/models/product.dart';
import 'package:smart_shop/providers/cart_provider.dart';
import 'package:smart_shop/providers/product_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final isFav = ctx.watch<ProductProvider>().favourites.any((p) => p.id == product.id);
    final tt = Theme.of(ctx).textTheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(children: [
        Expanded(child: Image.network(product.image, fit: BoxFit.contain)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: tt.titleMedium,
          ),
        ),
        Text('\$${product.price.toStringAsFixed(2)}', style: tt.bodyLarge),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < product.rating.floor(); i++)
              const Icon(Icons.star, size: 16, color: Colors.amber),
            if (product.rating - product.rating.floor() >= 0.5)
              const Icon(Icons.star_half, size: 16, color: Colors.amber),
            for (var i = 0; i < 5 - product.rating.ceil(); i++)
              const Icon(Icons.star_border, size: 16, color: Colors.amber),
          ],
        ),
        ButtonBar(alignment: MainAxisAlignment.spaceAround, children: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
            onPressed: () => ctx.read<ProductProvider>().toggleFav(product.id),
          ),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () => ctx.read<CartProvider>().add(product),
          ),
        ]),
      ]),
    );
  }
}
