// lib/ui/login_ui.dart
import 'package:flutter/material.dart';

class LoginUI extends StatefulWidget {
  final Future<bool> Function(String email, String password) onLogin;
  final VoidCallback onSignupTap;

  const LoginUI({Key? key, required this.onLogin, required this.onSignupTap})
    : super(key: key);

  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final ok = await widget.onLogin(_emailCtl.text.trim(), _passCtl.text);
    setState(() {
      _loading = false;
      if (!ok) _error = 'Invalid credentials';
    });
  }

  void _demoLogin() {
    _emailCtl.text = 'jane.doe@example.com';
    _passCtl.text = '123456';
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        children: [
          // Gradient header
          Container(
            height: 240,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.gif', height: 100),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome Back',
                    style: tt.headlineMedium?.copyWith(color: Colors.white),
                  ),
                ],
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
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailCtl,
                              style: tt.bodyLarge,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (v) => v != null && v.contains('@')
                                  ? null
                                  : 'Enter valid email',
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passCtl,
                              style: tt.bodyLarge,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              obscureText: true,
                              validator: (v) => v != null && v.length >= 6
                                  ? null
                                  : 'Min 6 chars',
                            ),
                          ],
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          style: tt.bodyLarge?.copyWith(color: Colors.red),
                        ),
                      ],
                      const SizedBox(height: 24),
                      _loading
                          ? const CircularProgressIndicator()
                          : Column(
                              children: [
                                ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    textStyle: tt.labelLarge,
                                  ),
                                  child: const Text('Login'),
                                ),
                                const SizedBox(height: 12),
                                OutlinedButton(
                                  onPressed: _demoLogin,
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    textStyle: tt.labelLarge,
                                  ),
                                  child: const Text('Demo Login'),
                                ),
                                const SizedBox(height: 12),
                                OutlinedButton(
                                  onPressed: widget.onSignupTap,
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    textStyle: tt.labelLarge,
                                  ),
                                  child: const Text('Create Account'),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
