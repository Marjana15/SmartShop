// lib/providers/product_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_shop/models/product.dart';
import 'package:smart_shop/services/api_service.dart';

enum SortOption { priceLowHigh, priceHighLow, ratingHighLow, ratingLowHigh }

class ProductProvider with ChangeNotifier {
  List<Product> _all = [];
  List<int> _favIds = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  SortOption? _sortOption;
  bool _loading = false;

  // NEW: search query
  String _searchQuery = '';

  ProductProvider() {
    _init();
  }

  Future<void> _init() async {
    await _fetch();
    await _fetchCategories();
    await _loadFavs();
  }

  Future<void> _fetch() async {
    _loading = true;
    notifyListeners();
    _all = await ApiService.fetchProducts();
    _loading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _fetch();
  }

  Future<void> _fetchCategories() async {
    _categories = await ApiService.fetchCategories();
    notifyListeners();
  }

  Future<void> _loadFavs() async {
    final p = await SharedPreferences.getInstance();
    _favIds = p.getStringList('favs')?.map(int.parse).toList() ?? [];
    notifyListeners();
  }

  // Expose categories, loading, etc.
  List<String> get categories => ['All', ..._categories];
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _loading;
  List<Product> get favourites =>
      _all.where((p) => _favIds.contains(p.id)).toList();

  // UPDATED: apply category, sort AND search
  List<Product> get displayed {
    var list = _all;

    if (_selectedCategory != 'All') {
      list = list.where((p) => p.category == _selectedCategory).toList();
    }
    if (_sortOption != null) {
      switch (_sortOption!) {
        case SortOption.priceLowHigh:
          list.sort((a, b) => a.price.compareTo(b.price));
          break;
        case SortOption.priceHighLow:
          list.sort((a, b) => b.price.compareTo(a.price));
          break;
        case SortOption.ratingHighLow:
          list.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case SortOption.ratingLowHigh:
          list.sort((a, b) => a.rating.compareTo(b.rating));
          break;
      }
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((p) => p.title.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  void toggleFav(int id) async {
    if (_favIds.contains(id)) _favIds.remove(id);
    else _favIds.add(id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'favs', _favIds.map((e) => e.toString()).toList());
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void sortProducts(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  // NEW: expose a search setter
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
