// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _email;
  String? _password;
  String? _firstName;
  String? _lastName;
  String? _phone;
  String? _address;
  bool _loggedIn = false;

  String? get email => _email;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get phone => _phone;
  String? get address => _address;
  bool get isLoggedIn => _loggedIn;

  AuthProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _email     = prefs.getString('email');
    _password  = prefs.getString('password');
    _firstName = prefs.getString('firstName');
    _lastName  = prefs.getString('lastName');
    _phone     = prefs.getString('phone');
    _address   = prefs.getString('address');
    _loggedIn  = prefs.getBool('loggedIn') ?? false;
    notifyListeners();
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);      // ← Persist password
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('phone', phone);
    await prefs.setString('address', address);
    await prefs.setBool('loggedIn', true);

    _email     = email;
    _password  = password;
    _firstName = firstName;
    _lastName  = lastName;
    _phone     = phone;
    _address   = address;
    _loggedIn  = true;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    // now _password has been set by register()
    if (email == _email && password == _password) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', true);
      _loggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    _loggedIn = false;
    notifyListeners();
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('phone', phone);
    await prefs.setString('address', address);

    _firstName = firstName;
    _lastName  = lastName;
    _phone     = phone;
    _address   = address;
    notifyListeners();
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    if (oldPassword == _password) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('password', newPassword);
      _password = newPassword;
      notifyListeners();
      return true;
    }
    return false;
  }
}
