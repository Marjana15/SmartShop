// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/providers/auth_provider.dart';
import 'package:smart_shop/providers/theme_provider.dart';
import 'package:smart_shop/screens/home_screen.dart';
import 'package:smart_shop/screens/cart_screen.dart';
import 'package:smart_shop/screens/fav_screen.dart';
import 'package:smart_shop/screens/profile_screen.dart';
import 'package:smart_shop/screens/login_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Widget _buildTile({
    required BuildContext ctx,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final tt = Theme.of(ctx).textTheme;
    final iconColor = Theme.of(ctx).colorScheme.primary;
    final bgColor = iconColor.withOpacity(0.1);
    final chevronColor = Theme.of(ctx).iconTheme.color;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: bgColor,
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: tt.bodyLarge),
      trailing: Icon(Icons.chevron_right, color: chevronColor),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    final themeProv = ctx.watch<ThemeProvider>();
    final auth = ctx.watch<AuthProvider>();
    final name = '${auth.firstName ?? 'Guest'} ${auth.lastName ?? ''}'.trim();
    final email = auth.email ?? 'guest@shop.com';
    final theme = Theme.of(ctx);
    final isDark = theme.brightness == Brightness.dark;

    // pick a darker gradient in dark mode
    final gradColors = isDark
        ? [theme.colorScheme.primaryContainer, theme.colorScheme.primary]
        : [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.7),
          ];

    final onPrimary = theme.colorScheme.onPrimary;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              name,
              style: TextStyle(
                color: onPrimary,
                fontWeight: FontWeight.w600,
                fontFamily: 'Grandis Extended',
              ),
            ),
            accountEmail: Text(
              email,
              style: TextStyle(color: onPrimary.withOpacity(0.8)),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.colorScheme.onPrimary,
              child: Text(
                name.isNotEmpty ? name[0] : 'G',
                style: TextStyle(
                  fontSize: 24,
                  color: theme.colorScheme.primary,
                  fontFamily: 'Grandis Extended',
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildTile(
                  ctx: ctx,
                  icon: Icons.home_filled,
                  title: 'Home',
                  onTap: () =>
                      Navigator.pushReplacementNamed(ctx, HomeScreen.routeName),
                ),
                _buildTile(
                  ctx: ctx,
                  icon: Icons.shopping_cart_outlined,
                  title: 'Cart',
                  onTap: () => Navigator.pushNamed(ctx, CartScreen.routeName),
                ),
                _buildTile(
                  ctx: ctx,
                  icon: Icons.favorite_border,
                  title: 'Favourites',
                  onTap: () => Navigator.pushNamed(ctx, FavScreen.routeName),
                ),
                _buildTile(
                  ctx: ctx,
                  icon: Icons.person_outline,
                  title: 'Profile',
                  onTap: () =>
                      Navigator.pushNamed(ctx, ProfileScreen.routeName),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Dark Mode', style: theme.textTheme.bodyLarge),
              secondary: Icon(
                themeProv.mode == ThemeMode.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
                color: theme.iconTheme.color,
              ),
              value: themeProv.mode == ThemeMode.dark,
              onChanged: (_) => ctx.read<ThemeProvider>().toggle(),
            ),
          ),

          ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.error.withOpacity(0.1),
              child: Icon(Icons.logout, color: theme.colorScheme.error),
            ),
            title: Text(
              'Logout',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            onTap: () {
              ctx.read<AuthProvider>().logout();
              Navigator.pushReplacementNamed(ctx, LoginScreen.routeName);
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
