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
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _passwordsMatch() {
    return _passwordController.text == _confirmPasswordController.text &&
        _passwordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.registered) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')),
        );
        Navigator.pushReplacementNamed(context, '/login');
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
            //this column contains name, email, password, confirm password, signup button, login redirect
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
                SizedBox(height: isTablet ? 30 : 20),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: const OutlineInputBorder(),
                    errorText: _confirmPasswordController.text.isNotEmpty &&
                            !_passwordsMatch()
                        ? "Passwords do not match"
                        : null,
                  ),
                ),
                SizedBox(height: isTablet ? 40 : 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Check if passwords match
                      if (!_passwordsMatch()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Passwords do not match'),
                          ),
                        );
                        return;
                      }
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
