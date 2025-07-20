// lib/screens/fav_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/providers/product_provider.dart';
import 'package:smart_shop/widgets/app_drawer.dart';
import 'package:smart_shop/widgets/product_card.dart';

class FavScreen extends StatelessWidget {
  static const routeName = '/favs';
  const FavScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<ProductProvider>().favourites;
    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      drawer: const AppDrawer(),
      body: favs.isEmpty
          ? const Center(child: Text('No favourites yet'))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: favs.length,
              itemBuilder: (_, i) => ProductCard(favs[i]),
            ),
    );
  }
}
