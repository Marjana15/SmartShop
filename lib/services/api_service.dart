// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_shop/models/product.dart';

class ApiService {
  static const _base = 'https://fakestoreapi.com';

  /// PRODUCTS

  static Future<List<Product>> fetchProducts() async {
    final res = await http.get(Uri.parse('$_base/products'));
    if (res.statusCode != 200) throw Exception('Failed to load products');
    final List data = jsonDecode(res.body);
    return data.map((e) => Product.fromJson(e)).toList();
  }

  static Future<List<String>> fetchCategories() async {
    final res = await http.get(Uri.parse('$_base/products/categories'));
    if (res.statusCode != 200) throw Exception('Failed to load categories');
    final List data = jsonDecode(res.body);
    return data.cast<String>();
  }

  /// AUTH

  /// Returns a JWT token on successful login.
  static Future<String> login({
    required String username,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$_base/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      return body['token'] as String;
    }
    throw Exception('Login failed (status ${res.statusCode})');
  }

  /// Registers a new user; returns the created user object.
  static Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
    required Map<String, String> name,     // {'firstname': 'John', 'lastname': 'Doe'}
    required Map<String, dynamic> address, // {'city': 'X', 'street': 'Y', 'number': 123}
    required String phone,
  }) async {
    final res = await http.post(
      Uri.parse('$_base/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'username': username,
        'password': password,
        'name': name,
        'address': address,
        'phone': phone,
      }),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Register failed (status ${res.statusCode})');
  }

  /// USER PROFILES

  /// Fetches all users so you can look up the current user’s profile by email/ID.
  static Future<List<Map<String, dynamic>>> fetchUsers() async {
    final res = await http.get(Uri.parse('$_base/users'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Could not fetch users');
  }
}
