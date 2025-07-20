// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/providers/auth_provider.dart';
import 'package:smart_shop/providers/theme_provider.dart';
import 'package:smart_shop/providers/product_provider.dart';
import 'package:smart_shop/providers/cart_provider.dart';
import 'package:smart_shop/screens/splash_screen.dart';
import 'package:smart_shop/screens/login_screen.dart';
import 'package:smart_shop/screens/register_screen.dart';
import 'package:smart_shop/screens/home_screen.dart';
import 'package:smart_shop/screens/cart_screen.dart';
import 'package:smart_shop/screens/fav_screen.dart';
import 'package:smart_shop/screens/profile_screen.dart';
import 'package:smart_shop/screens/checkout_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const SmartShopApp(),
    ),
  );
}

class SmartShopApp extends StatelessWidget {
  const SmartShopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProv = context.watch<ThemeProvider>();

    // Light uses dark text, dark uses light text
    final baseLight = Typography.material2018().black.apply(fontFamily: 'Plus Jakarta');
    final baseDark = Typography.material2018().white.apply(fontFamily: 'Plus Jakarta');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Shop',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Plus Jakarta',
        textTheme: baseLight.copyWith(
          headlineMedium: baseLight.headlineMedium?.copyWith(
            fontFamily: 'Grandis Extended',
            fontWeight: FontWeight.w700,
          ),
          titleLarge: baseLight.titleLarge?.copyWith(
            fontFamily: 'Grandis Extended',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Plus Jakarta',
        textTheme: baseDark.copyWith(
          headlineMedium: baseDark.headlineMedium?.copyWith(
            fontFamily: 'Grandis Extended',
            fontWeight: FontWeight.w700,
          ),
          titleLarge: baseDark.titleLarge?.copyWith(
            fontFamily: 'Grandis Extended',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      themeMode: themeProv.mode,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        CartScreen.routeName: (_) => const CartScreen(),
        FavScreen.routeName: (_) => const FavScreen(),
        ProfileScreen.routeName: (_) => const ProfileScreen(),
        CheckoutScreen.routeName: (_) => const CheckoutScreen(),
      },
    );
  }
}
