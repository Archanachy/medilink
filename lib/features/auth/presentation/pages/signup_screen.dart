import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/auth/presentation/states/auth_state.dart';
import 'package:medilink/features/auth/presentation/view_model/auth_view_model.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.registered) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')),
        );
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Registration Error')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: LayoutBuilder(
        builder: (context, c) {
          bool isTablet = c.maxWidth > 600;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 80 : 20,
              vertical: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Create Your Account",
                    style: TextStyle(
                      fontSize: isTablet ? 30 : 24,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: isTablet ? 30 : 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: isTablet ? 30 : 20),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: isTablet ? 30 : 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: isTablet ? 40 : 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // DO NOT navigate here — wait for state listener to navigate on success
                      ref.read(authViewModelProvider.notifier).register(
                            fullName: _nameController.text.trim(),
                            email: _emailController.text.trim(),
                            userName: _usernameController.text.trim(),
                            password: _passwordController.text,
                          );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(isTablet ? 20 : 14),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontSize: isTablet ? 22 : 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text("Already have an account? Login"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
