// lib/screens/home_screen.dart
import 'package:flutter/material.dart' hide Badge;
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/providers/cart_provider.dart';
import 'package:smart_shop/providers/product_provider.dart';
import 'package:smart_shop/widgets/app_drawer.dart';
import 'package:smart_shop/widgets/sort_menu.dart';
import 'package:smart_shop/widgets/product_card.dart';
import 'package:smart_shop/widgets/product_skeleton.dart';
import 'package:smart_shop/screens/cart_screen.dart';
import 'package:smart_shop/screens/fav_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  void _openSortMenu(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Theme.of(ctx).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const SortMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prodProv = context.watch<ProductProvider>();
    final cartProv = context.watch<CartProvider>();
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            tooltip: 'Favourites',
            onPressed: () =>
                Navigator.pushNamed(context, FavScreen.routeName),
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, CartScreen.routeName),
            tooltip: 'Cart',
            icon: Badge(
              position: BadgePosition.topEnd(top: -4, end: -6),
              badgeColor: theme.colorScheme.error,
              animationType: BadgeAnimationType.scale,
              badgeContent: Text(
                cartProv.count.toString(),
                style: tt.bodySmall
                    ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
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
      body: Column(
        children: [
          // Search & Sort Controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: prodProv.setSearchQuery,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Material(
                  shape: const CircleBorder(),
                  color: theme.colorScheme.secondary,
                  child: IconButton(
                    icon: const Icon(Icons.sort, color: Colors.white),
                    onPressed: () => _openSortMenu(context),
                  ),
                ),
              ],
            ),
          ),

          // Category chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: prodProv.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final cat = prodProv.categories[i];
                final selected = cat == prodProv.selectedCategory;
                return ChoiceChip(
                  label: Text(cat),
                  selected: selected,
                  onSelected: (_) => prodProv.setCategory(cat),
                  selectedColor: theme.colorScheme.primary,
                  backgroundColor: theme.colorScheme.surface,
                  labelStyle: tt.bodyLarge?.copyWith(
                    color: selected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Products Grid with skeletons
          Expanded(
            child: RefreshIndicator(
              onRefresh: prodProv.refresh,
              child: prodProv.isLoading
                  // Show skeleton placeholders when loading
                  ? GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                      itemCount: 6,
                      itemBuilder: (_, __) => const ProductSkeleton(),
                    )
                  // Show real products when loaded
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                      itemCount: prodProv.displayed.length,
                      itemBuilder: (_, i) =>
                          ProductCard(prodProv.displayed[i]),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
