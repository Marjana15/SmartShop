// lib/widgets/sort_menu.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/providers/product_provider.dart';

class SortMenu extends StatelessWidget {
  const SortMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prodProv = context.read<ProductProvider>();
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    final options = [
      {'label': 'Price: Low → High', 'opt': SortOption.priceLowHigh},
      {'label': 'Price: High → Low', 'opt': SortOption.priceHighLow},
      {'label': 'Rating: High → Low', 'opt': SortOption.ratingHighLow},
      {'label': 'Rating: Low → High', 'opt': SortOption.ratingLowHigh},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Sort Products', style: tt.headlineSmall),
          const SizedBox(height: 12),
          ...options.map((e) {
            return Card(
              color: theme.colorScheme.surface,
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(e['label']! as String, style: tt.bodyLarge),
                trailing: Icon(Icons.chevron_right, color: theme.colorScheme.primary),
                onTap: () {
                  prodProv.sortProducts(e['opt'] as SortOption);
                  Navigator.pop(context);
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}