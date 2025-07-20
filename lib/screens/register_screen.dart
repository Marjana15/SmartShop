// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/providers/auth_provider.dart';
import 'package:smart_shop/screens/login_screen.dart';
import 'package:smart_shop/screens/home_screen.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = '/register';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        children: [
          // Gradient header
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: SafeArea(
              child: Center(
                child: Text(
                  'Join Smart Shop',
                  style: tt.headlineMedium?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),

          // Form card
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: _RegisterForm(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();

  bool _loading = false, _obscure = true;
  String? _error;

  void _demoFill() {
    setState(() {
      _first.text = 'Jane';
      _last.text = 'Doe';
      _email.text = 'jane.doe@example.com';
      _pass.text = '123456';
      _confirm.text = '123456';
      _phone.text = '+1234567890';
      _address.text = '123 Demo Street';
      _error = null;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pass.text != _confirm.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });

    await context.read<AuthProvider>().register(
      email: _email.text.trim(),
      password: _pass.text,
      firstName: _first.text.trim(),
      lastName: _last.text.trim(),
      phone: _phone.text.trim(),
      address: _address.text.trim(),
    );

    setState(() {
      _loading = false;
    });

    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildField(_first, 'First Name', tt)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildField(_last, 'Last Name', tt)),
                ],
              ),
              const SizedBox(height: 16),
              _buildField(
                _email,
                'Email',
                tt,
                keyboard: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildField(
                _pass,
                'Password',
                tt,
                obscure: _obscure,
                suffix: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              const SizedBox(height: 16),
              _buildField(_confirm, 'Confirm Password', tt, obscure: _obscure),
              const SizedBox(height: 16),
              _buildField(_phone, 'Phone', tt, keyboard: TextInputType.phone),
              const SizedBox(height: 16),
              _buildField(_address, 'Address', tt),
            ],
          ),
        ),

        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: tt.bodyLarge?.copyWith(color: Colors.red)),
        ],

        const SizedBox(height: 24),
        if (_loading)
          const CircularProgressIndicator()
        else ...[
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: tt.labelLarge,
            ),
            child: const Text('Register'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _demoFill,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: tt.labelLarge,
            ),
            child: const Text('Demo Register'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, LoginScreen.routeName),
            child: Text('Already have an account? Login', style: tt.bodyLarge),
          ),
        ],
      ],
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label,
    TextTheme tt, {
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: ctrl,
      style: tt.bodyLarge,
      keyboardType: keyboard,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: suffix,
      ),
      validator: (v) => (v != null && v.isNotEmpty) ? null : 'Required',
    );
  }
}
