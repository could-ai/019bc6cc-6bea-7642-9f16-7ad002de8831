import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/user.dart';
import '../services/mock_data_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;

  @override
  void initState() {
    super.initState();
    _initializeMockUser();
  }

  Future<void> _initializeMockUser() async {
    final dataService = MockDataService();
    await dataService.initializeMockData();
    final users = await dataService.getUsers();
    if (users.isNotEmpty) {
      _emailController.text = users[0].email;
      _nameController.text = users[0].name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Expense Manager')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isLogin ? 'Login' : 'Sign Up',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            if (!_isLogin)
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
            if (!_isLogin) const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _handleAuth,
              child: Text(_isLogin ? 'Login' : 'Sign Up'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => setState(() => _isLogin = !_isLogin),
              child: Text(_isLogin ? 'Create Account' : 'Already have account?'),
            ),
            const SizedBox(height: 16),
            const Text('Or continue with:'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _loginWithGoogle,
                  icon: const Icon(Icons.g_mobiledata),
                  label: const Text('Google'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _loginWithApple,
                  icon: const Icon(Icons.apple),
                  label: const Text('Apple'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleAuth() {
    // Mock authentication - just login with first user
    final user = User(
      id: '1',
      name: _nameController.text.isEmpty ? 'Demo User' : _nameController.text,
      email: _emailController.text.isEmpty ? 'demo@example.com' : _emailController.text,
    );
    context.read<AppProvider>().login(user);
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _loginWithGoogle() {
    // TODO: Implement Google auth when Supabase is connected
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google login not implemented yet - Supabase connection required')),
    );
  }

  void _loginWithApple() {
    // TODO: Implement Apple auth when Supabase is connected
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple login not implemented yet - Supabase connection required')),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}