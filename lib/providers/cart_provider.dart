// lib/providers/cart_provider.dart
import 'package:flutter/foundation.dart';
import 'package:smart_shop/models/cart_item.dart';
import 'package:smart_shop/models/product.dart';

class CartProvider with ChangeNotifier {
  // key: productId
  final Map<int, CartItem> _items = {};

  // Add one item
  void add(Product p) {
    if (_items.containsKey(p.id)) {
      _items[p.id]!.quantity++;
    } else {
      _items[p.id] = CartItem(product: p, quantity: 1);
    }
    notifyListeners();
  }

  // Remove one unit; if zero, remove entry
  void removeSingle(int productId) {
    final item = _items[productId];
    if (item == null) return;
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  // Remove all of that product
  void remove(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // Clear cart
  void clear() {
    _items.clear();
    notifyListeners();
  }

  // List of CartItem
  List<CartItem> get items => _items.values.toList();

  // Total items count
  int get count =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  // Total price
  double get total => _items.values
      .fold(0.0, (sum, item) => sum + item.product.price * item.quantity);
}
