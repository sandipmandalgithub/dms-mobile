import 'package:flutter/material.dart';

import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../widgets/email_field.dart';
import '../widgets/login_button.dart';
import '../widgets/login_footer.dart';
import '../widgets/login_header.dart';
import '../widgets/password_field.dart';
import '../widgets/remember_me.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const LoginHeader(),
                  const SizedBox(height: 36),
                  Container(
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Welcome back',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF172B4D),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sign in to access your documents.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF718096),
                            ),
                          ),
                          const SizedBox(height: 28),
                          EmailField(controller: _emailController),
                          const SizedBox(height: 20),
                          PasswordField(
                            controller: _passwordController,
                            obscurePassword: _obscurePassword,
                            onVisibilityChanged: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          RememberMe(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          LoginButton(onPressed: _login),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const LoginFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
