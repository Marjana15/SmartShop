// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/providers/auth_provider.dart';
import 'package:smart_shop/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
  const ProfileScreen({Key? key}) : super(key: key);

  Future<void> _editField({
    required BuildContext context,
    required String title,
    required String initialValue,
    required ValueChanged<String> onSave,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
  }) {
    final ctrl = TextEditingController(text: initialValue);
    final formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit $title'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: ctrl,
            keyboardType: keyboardType,
            obscureText: obscure,
            decoration: InputDecoration(labelText: title),
            validator: (v) => v != null && v.isNotEmpty ? null : 'Required',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              onSave(ctrl.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _changePassword(BuildContext context) {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: oldCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Old Password'),
                validator: (v) => v != null && v.isNotEmpty ? null : 'Required',
              ),
              TextFormField(
                controller: newCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
                validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 chars',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final ok = await context.read<AuthProvider>().changePassword(
                    oldPassword: oldCtrl.text,
                    newPassword: newCtrl.text,
                  );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(ok ? 'Password updated' : 'Old password incorrect'),
                ),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final first = auth.firstName ?? '';
    final last = auth.lastName ?? '';
    final email = auth.email ?? '';
    final phone = auth.phone ?? '';
    final address = auth.address ?? '';
    final initials = '${first.isNotEmpty ? first[0] : ''}${last.isNotEmpty ? last[0] : ''}';
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: ListView(
        children: [
          // Header
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Text(
                      initials,
                      style: tt.headlineMedium?.copyWith(color: const Color(0xFF6A1B9A)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$first $last',
                    style: tt.headlineMedium?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Account Information
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Email'),
                subtitle: Text(email, style: tt.bodyLarge),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.phone_outlined),
                title: const Text('Phone'),
                subtitle: Text(phone, style: tt.bodyLarge),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _editField(
                    context: context,
                    title: 'Phone',
                    initialValue: phone,
                    keyboardType: TextInputType.phone,
                    onSave: (val) => auth.updateProfile(
                      firstName: first,
                      lastName: last,
                      phone: val,
                      address: address,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Address'),
                subtitle: Text(address, style: tt.bodyLarge),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _editField(
                    context: context,
                    title: 'Address',
                    initialValue: address,
                    onSave: (val) => auth.updateProfile(
                      firstName: first,
                      lastName: last,
                      phone: phone,
                      address: val,
                    ),
                  ),
                ),
              ),
            ]),
          ),

          const SizedBox(height: 24),

          // PROMINENT Change Password Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: tt.titleMedium?.copyWith(color: Colors.white),
              ),
              icon: const Icon(Icons.lock_outline, color: Colors.white),
              label: const Text('Change Password', style: TextStyle(color: Colors.white)),
              onPressed: () => _changePassword(context),
            ),
          ),

          const SizedBox(height: 16),

          // Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: tt.labelLarge,
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Logout', style: TextStyle(color: Colors.white)),
              onPressed: () {
                auth.logout();
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
