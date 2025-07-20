// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/providers/auth_provider.dart';
import 'package:smart_shop/ui/login_ui.dart';
import 'package:smart_shop/screens/register_screen.dart';
import 'package:smart_shop/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginUI(
      onLogin: (email, pass) async {
        final ok = await context.read<AuthProvider>().login(email: email, password: pass);
        if (ok) Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        return ok;
      },
      onSignupTap: () => Navigator.pushNamed(context, RegisterScreen.routeName),
    );
  }
}
